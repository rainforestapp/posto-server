class GiftCreditsController < ApplicationController
  layout "gift"

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
      @title = "babygrams: Buy credits for #{@sender_name}"
      @postcard_subject = @card_order.card_design.postcard_subject
      @postcard_subject_first_name = @postcard_subject[:name].split(" ").first
      @recipient_name = @card_printing.recipient_user.try(:user_profile).try(:name) || ""

      @credits = @sender.credits_for_app(@app)

      @number_of_cards = @credits / @config.card_credits

      if @number_of_cards <= 0
        @credit_message = "#{@sender} is all out of credits."
      else
        @credit_message = "#{@sender_profile.subject_pronoun.capitalize} currently has #{@credits} credits, enough to send #{@number_of_cards} more #{"card".pluralize(@number_of_cards)}."
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
  end
end
