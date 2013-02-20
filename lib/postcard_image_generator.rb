class PostcardImageGenerator
  BORDER_SIZE = 0.05
  TEMPLATE_PATH = "resources/postcards/lulcards/1"

  attr_accessor :card_order

  def generate!
    raise "Must set card order" unless self.card_order
    raise "No recipients" unless self.card_order.card_printings.size > 0

    @card_design = card_order.card_printings[0].card_design

  end
end
