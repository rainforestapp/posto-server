class GiftCreditsController < ApplicationController
  include ForceSsl

  layout "gift"

  PACKAGE_MAP = { 
    "sheep" => 96, "monkey" => 97, "elephant" => 99 
  }

  def index
    @app = App.by_name(params[:app_id])
    @title = "babygrams: enter your babygram code"
  end

  def show
    @app = App.by_name(params[:app_id])

    @config = CONFIG.for_app(@app)
    @card_printing = CardPrinting.find_by_lookup_number(params[:id].to_i)

    if @card_printing
      @card_order = @card_printing.card_order
      @sender = @card_order.order_sender_user
      @sender_profile = @sender.user_profile
      @title = "babygrams: Thank #{@sender_name} for your babygram"
      @postcard_subject = @card_order.card_design.postcard_subject
      @postcard_subject_first_name = @postcard_subject[:name].split(" ").first
      @recipient_name = @card_printing.recipient_user.try(:user_profile).try(:name) || ""

      @credits = @sender.credits_for_app(@app)

      @number_of_cards = @credits / @config.card_credits

      if @number_of_cards <= 0
        @credit_message = "#{@sender_profile.first_name} is all out of credits."
      else
        @credit_message = "#{@sender_profile.subject_pronoun.capitalize} currently has #{@credits} credits, enough to send #{@number_of_cards} more #{"card".pluralize(@number_of_cards)}."
      end

      @show_packages = @number_of_cards < 3

      @packages = []

      PACKAGE_MAP.each do |name, package_id|
        package = @config.credit_packages.find { |p| p[:credit_package_id] == package_id }
        @packages << package.merge(name: name)
      end
    end

    respond_to do |format|
      format.json do 
        if @card_printing
          render json: { card_printing_id: @card_printing.card_printing_id }
        else
          render json: { }
        end
      end

      format.html do
        render
      end
    end
  end

  def create
    name = params[:name]
    return head :bad_request unless name.try(:size) > 2

    email = params[:email]
    return head :bad_request unless email.try(:size) > 2 && email.to_s =~ /\@/ && email.to_s =~ /\./

    giftee_user_id = params[:giftee_user_id]
    @giftee = User.find(giftee_user_id)
    return head :bad_request unless @giftee

    package_id = params[:credit_package_id]
    no_package = package_id == ""
    return head :bad_request unless package_id

    stripe_token = params[:stripe_token]
    return head :bad_request unless stripe_token || no_package

    @app = App.by_name(params[:app_id])
    return head :bad_request unless @app

    @card_printing = CardPrinting.find(params[:card_printing_id])
    return head :bad_request unless @card_printing

    @config = CONFIG.for_app(@app)
    @package = @config.credit_packages.find { |p| p[:credit_package_id] == package_id.to_i }

    return head :bad_request unless @package || no_package

    @title = no_package ? "babygrams: Your thank-you-note has been sent!" : "babygrams: Thank you for your order!"

    note = (params[:note] || "")[0..512]
    remind_empty = params[:remind_empty] == "on"

    @gifter = nil

    Person.transaction_with_retry do
      @gifter = Person.where(email: email).lock(true).first
      @gifter ||= Person.create!(email: email)
      @gifter.person_profiles.create!(name: name)
      @gifter.person_notification_preferences.create!(target_id: @giftee.user_id,
                                                      notification_type: :empty_credits,
                                                      enabled: remind_empty)
    end

    charge = nil
    @success = true

    unless no_package
      begin
        charge = Stripe::Charge.create(
          amount: @package[:price],
          currency: "usd",
          card: stripe_token,
          description: "Charge #{@package[:credits]} Gift Credits"
        )

        @success = false if charge["failure_message"]
      rescue Exception => e
        Airbrake.notify_or_ignore(e, parameters: params)
        @success = false
      end

      if @success
        begin
          CreditOrder.transaction_with_retry do
            @credit_order = @giftee.credit_orders.create!(app_id: @app.app_id,
                                                          credits: @package[:credits],
                                                          gifter_person_id: @gifter.person_id,
                                                          price: @package[:price],
                                                          note: note)

            @giftee.add_credits!(@package[:credits],
                                app: @app,
                                source_type: :credit_order,
                                source_id: @credit_order.credit_order_id)
          end
        rescue Exception => e
          charge.refund rescue nil
          Airbrake.notify_or_ignore(e, parameters: params)
          @success = false
        end
      end
    end

    if @success
      if @credit_order
        [:credit_order_receipt, :admin_audit_credit_order].each do |email_type|
          begin
            CreditOrderMailer.send(email_type, @credit_order).try(:deliver)
          rescue Exception => e
            Airbrake.notify_or_ignore(e)
          end
        end
      end

      email_args = { person_id: @gifter.person_id,
                     app_id: @app.app_id,
                     card_printing_id: @card_printing.card_printing_id,
                     note: note }

      email_args[:credit_order_id] = @credit_order.credit_order_id if @credit_order

      OutgoingEmailTask.transaction_with_retry do
        OutgoingEmailTask.create(workload_id: SecureRandom.hex,
                                 workload_index: 0,
                                 email_type: :thank_you,
                                 email_args: email_args,
                                 email_variant: "default",
                                 app_id: @app.app_id,
                                 recipient_user_id: @giftee.user_id).send!
      end

      begin
        message = "#{@gifter.person_profile.name} e-mailed you a thank-you-note for your babygram!"

        if @credit_order
          message = "#{@credit_order.orderer_name} just bought you #{@credit_order.credits} #{@app.name} credits!"
        end

        @giftee.send_notification(message, app: @app)
      rescue Exception => e
        Airbrake.notify_or_ignore(e)
      end
    end

    render
  end
end
