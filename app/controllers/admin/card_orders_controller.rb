class Admin::CardOrdersController < AdminControllerBase
  def show
    @card_order = CardOrder.find(params[:id])
    composition = @card_order.card_printings[0].card_printing_composition
    @sender = @card_order.order_sender_user
    @front_url = composition.jpg_card_front_image.public_url
    @back_url = composition.jpg_card_back_image.public_url
    @front_pdf_url = composition.card_front_image.public_url
    @back_pdf_url = composition.card_back_image.public_url
    @all_card_count = @card_order.card_printings.size
    @mailable_card_printings = @card_order.mailable_card_printings
    @mailable_card_count = @mailable_card_printings.size
    @total_credits = @card_order.allocated_credits
    @total_price = "$%.02f" % (@card_order.total_price_to_charge / 100.0).to_s
  end
end
