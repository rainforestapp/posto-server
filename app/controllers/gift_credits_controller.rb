require "date_helper"

class GiftCreditsController < ApplicationController
  include ForceSsl

  layout "gift"

  def index
    @app = App.by_name(params[:app_id])
    @review_url = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=#{@app.apple_app_id}&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"
    @title = "babygrams: enter your babygram code"
  end

  class CardPrintingGiftCreditOrigin
    def initialize(card_printing)
      @card_printing = card_printing
      @card_order = card_printing.card_order
      @app = @card_order.app
    end

    def is_promo
      @card_order.is_promo
    end

    def is_self
      @card_order.order_sender_user == @card_printing.recipient_user
    end

    def has_plan
      self.is_self && @card_order.order_sender_user.credit_plan_id_for_app(@app)
    end

    def sender
      @card_order.order_sender_user
    end

    def postcard_subject
      @card_order.card_design.postcard_subject
    end

    def postcard_subject_first_name
      self.postcard_subject && self.postcard_subject[:name] && self.postcard_subject[:name].split(" ").first
    end

    def recipient_user
      @card_printing.recipient_user
    end

    def recipient_name
      @card_printing.recipient_user.try(:user_profile).try(:name) || ""
    end

    def app
      @app
    end

    def image_url
      @card_printing.card_printing_composition.jpg_card_front_image.public_ssl_url
    end

    def post_id_name
      "card_printing_id"
    end

    def post_id_value
      @card_printing.card_printing_id
    end

    def bonus_credits
      if self.is_promo
        CONFIG.for_app(@app).card_credits
      else
        0
      end
    end

    def redeem_promo!
      @card_order.redeem_promo!
    end

    def main_message
      "We hope you enjoyed<br/>your #{CONFIG.for_app(@app).entity}!"
    end
  end

  class CreditPromoGiftCreditOrigin
    def initialize(credit_promo, postcard_subject)
      @credit_promo = credit_promo
      @postcard_subject = postcard_subject

      @user = @credit_promo.intended_recipient_user
      @app = @credit_promo.app

      if @postcard_subject
        raise "mismatch" unless @credit_promo.app == @postcard_subject.app
        raise "mismatch" unless @credit_promo.intended_recipient_user == @postcard_subject.user
      end
    end

    def is_promo
      true
    end

    def is_self
      true
    end

    def has_plan
      self.is_self && @user.credit_plan_id_for_app(@app)
    end

    def sender
      @user
    end

    def postcard_subject
      @postcard_subject
    end

    def postcard_subject_first_name
      @postcard_subject[:name].split(" ").first
    end

    def recipient_user
      @user
    end

    def recipient_name
      @user.try(:user_profile).try(:name) || ""
    end

    def app
      @app
    end

    def image_url
      return @image_url if @image_url

      @user.card_orders.each do |order|
        if !postcard_subject ||
           (order.card_design.postcard_subject && order.card_design.postcard_subject[:name] == @postcard_subject.name)
          @image_url = order.card_printings[0].card_printing_composition.try(:jpg_card_front_image).try(:public_ssl_url)
        end
      end

      return @image_url || "https://s3-us-west-1.amazonaws.com/posto-assets/babygrams/#{@postcard_subject.try(:gender) || "boy"}_card.png"
    end

    def post_id_name
      "credit_promo_uid"
    end

    def post_id_value
      @credit_promo.uid
    end

    def bonus_credits
      @credit_promo.credits
    end

    def redeem_promo!
      @credit_promo.grant_to!(@user)
    end

    def main_message
      age = DateHelper.printable_age(Time.now, @postcard_subject.birthday - 2.days, true)
      "#{self.postcard_subject_first_name} is #{age} old!"
    end
  end

  def show
    @app = App.by_name(params[:app_id])

    @config = CONFIG.for_app(@app)
    card_printing = CardPrinting.find_by_lookup_number(params[:id].to_i)

    if card_printing
      @origin = CardPrintingGiftCreditOrigin.new(card_printing)
    else
      credit_promo = CreditPromo.where(uid: params[:id]).first
      postcard_subject = PostcardSubject.find(params[:postcard_subject_id])

      if credit_promo && postcard_subject
        @origin = CreditPromoGiftCreditOrigin.new(credit_promo, postcard_subject)
      end
    end

    if @origin && @origin.app == @app
      @is_promo = @origin.is_promo
      @is_self = @origin.is_self
      @has_plan = @origin.has_plan
      @sender = @origin.sender
      @sender_profile = @sender.user_profile

      if @is_self
        @title = "babygrams: Thank you for using #{@app.name}"
      else
        @title = "babygrams: Thank #{@sender_name} for your babygram"
      end

      @postcard_subject = @origin.postcard_subject
      @postcard_subject_first_name = @origin.postcard_subject_first_name
      @recipient_name = @origin.recipient_name

      @credits = @sender.credits_for_app(@app)

      @number_of_cards = @credits / @config.card_credits

      unless @is_self
        if @number_of_cards <= 0
          @credit_message = "#{@sender_profile.first_name} is all out of credits."
        else
          @credit_message = "#{@sender_profile.subject_pronoun.capitalize} currently has #{@credits} credits, enough to send #{@number_of_cards} more #{"card".pluralize(@number_of_cards)}."
        end
      end

      @show_packages = @number_of_cards < 3 || @is_promo || @is_self

      @packages = []

      @use_plans = @is_self && !@has_plan

      @credit_key_name = @use_plans ? :credit_plan_id : :credit_package_id

      ["sheep", "monkey", "elephant"].each_with_index do |name, index|
        available_credit_plans = @config.all_credit_plans.select { |p| @config.available_credit_plans.include?(p[:credit_plan_id]) }
        @packages << (@use_plans ? available_credit_plans : @config.credit_packages)[index].merge(name: name)
      end

      @max_savings = @packages.map { |x| x[:savings] }.max
    end

    respond_to do |format|
      format.json do 
        if @origin
          out = {}
          out[@origin.post_id_name.to_sym] = @origin.post_id_value

          render json: out
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
    if params[:card_printing_id]
      card_printing = CardPrinting.find(params[:card_printing_id])

      if card_printing
        @origin = CardPrintingGiftCreditOrigin.new(card_printing)
      end
    elsif params[:credit_promo_uid]
      @origin = CreditPromoGiftCreditOrigin.new(CreditPromo.where(uid: params[:credit_promo_uid]).first, nil)
    end

    return head :bad_request unless @origin

    @is_promo = @origin.is_promo
    @is_self = @origin.is_self

    unless @is_self
      name = params[:name]
      return head :bad_request unless name.try(:size) > 2

      email = params[:email]
      return head :bad_request unless email.try(:size) > 2 && email.to_s =~ /\@/ && email.to_s =~ /\./
    end

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

    @review_url = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=#{@app.apple_app_id}&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"

    @is_plan = false

    @config = CONFIG.for_app(@app)
    @package = @config.credit_packages.find { |p| p[:credit_package_id] == package_id.to_i }

    unless @package
      @package = @config.credit_plans.find { |p| p[:credit_plan_id] == package_id.to_i }
      @is_plan = true
    end

    return head :bad_request unless @package || no_package

    @title = no_package ? "babygrams: Your thank-you-note has been sent!" : "babygrams: Thank you for your order!"

    if @is_self
      @title = no_package ? "babygrams: Your credits are redeemed!" : "babygrams: Thank you for your order!"
    else
      @title = no_package ? "babygrams: Your thank-you-note has been sent!" : "babygrams: Thank you for your order!"
    end

    note = (params[:note] || "")[0..512]
    remind_empty = params[:remind_empty] == "on"

    @gifter = nil

    unless @is_self
      Person.transaction_with_retry do
        @gifter = Person.where(email: email).lock(true).first
        @gifter ||= Person.create!(email: email)
        @gifter.person_profiles.create!(name: name)
        @gifter.person_notification_preferences.create!(target_id: @giftee.user_id,
                                                        notification_type: :empty_credits,
                                                        enabled: remind_empty)
      end
    end

    charge = nil
    @success = true

    unless no_package
      begin
        charge_description = "Charge #{@package[:credits]} #{@is_self ? "Self " : ""}Gift Credits"
        charge = nil

        if @is_self && @is_plan
          @giftee.set_stripe_payment_info_with_token(stripe_token)
          stripe_customer = @giftee.stripe_customer
          customer = Stripe::Customer.retrieve(stripe_customer.stripe_id)

          begin
            charge = Stripe::Charge.create(
              amount: @package[:price],
              currency: "usd",
              customer: customer["id"],
              description: charge_description
            )
          rescue Stripe::CardError => e
            begin
              stripe_customer.stripe_customer_card.mark_as_declined!
              stripe_customer.stripe_customer_card.append_to_metadata!(message: e.message)
            rescue Exception => ex
            end

            @success = false
          end
        else
          charge = Stripe::Charge.create(
            amount: @package[:price],
            currency: "usd",
            card: stripe_token,
            description: charge_description
          )
        end

        @success = false if charge["failure_message"]
      rescue Exception => e
        Airbrake.notify_or_ignore(e, parameters: params)
        @success = false
      end

      if @success
        begin
          CreditOrder.transaction_with_retry do
            if @gifter
              @credit_order = @giftee.credit_orders.create!(app_id: @app.app_id,
                                                            credits: @package[:credits],
                                                            gifter_person_id: @gifter.person_id,
                                                            price: @package[:price],
                                                            note: note)
            else
              @credit_order = @giftee.credit_orders.create!(app_id: @app.app_id,
                                                            credits: @package[:credits],
                                                            price: @package[:price])
            end

            @giftee.add_credits!(@package[:credits],
                                app: @app,
                                source_type: :credit_order,
                                source_id: @credit_order.credit_order_id)

            if @package[:bonus] && @package[:bonus] > 0
              @giftee.add_credits!(@package[:bonus],
                                  app: @app,
                                  source_type: :credit_order_bonus,
                                  source_id: @credit_order.credit_order_id)
            end
          end

          if @is_plan && @success
            @giftee.credit_plan_membership_for_app(@app).try(:cancel!)

            @giftee.credit_plan_memberships.create!(
              app_id: @app.app_id, 
              credit_plan_price: @package[:price],
              credit_plan_credits: @package[:credits],
              credit_plan_id: @package[:credit_plan_id]
            )
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

      if @gifter
        email_args = { person_id: @gifter.person_id,
                      app_id: @app.app_id,
                      note: note }

        email_args[@origin.post_id_name.to_sym] = @origin.post_id_value

        email_args[:credit_order_id] = @credit_order.credit_order_id if @credit_order

        if @giftee.try(:user_profile).try(:email)
          OutgoingEmailTask.transaction_with_retry do
            OutgoingEmailTask.create(workload_id: SecureRandom.hex,
                                    workload_index: 0,
                                    email_type: :thank_you,
                                    email_args: email_args,
                                    email_variant: "default",
                                    app_id: @app.app_id,
                                    recipient_user_id: @giftee.user_id).send!
          end
        end

        begin
          message = "#{@gifter.person_profile.name} e-mailed you a thank-you-note for your babygram!"

          if note && note.size < 80
            message = "#{@gifter.person_profile.name} thanked you for your babygram: #{note}"
          end

          if @credit_order
            message = "#{@credit_order.orderer_name} just bought you #{@credit_order.credits} #{@app.name} credits!"
          end

          @giftee.send_notification(message, app: @app)
        rescue Exception => e
          Airbrake.notify_or_ignore(e)
        end
      end
    end

    if @success && @origin.is_promo
      @origin.redeem_promo!
    end

    render
  end
end
