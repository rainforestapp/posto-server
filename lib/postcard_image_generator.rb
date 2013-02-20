require "tempfile"
require "open-uri"

class PostcardImageGenerator
  BORDER_SIZE = 0.05
  TEMPLATE_PATH = "resources/postcards/lulcards/1"

  attr_accessor :card_order

  def generate!
    raise "Must set card order" unless self.card_order
    raise "No recipients" unless self.card_order.card_printings.size > 0

    @card_design = card_order.card_design

    composite_file = "#{SecureRandom.hex}.jpg"

    Tempfile.open(composite_file, Dir.tmpdir, mode: 'wb') do |composite_temp_file|
      open(@card_design.composed_full_photo_image.public_url, 'rb') do |composite_image|
        composite_temp_file.write(composite_image.read)
        composite_temp_file.close
      end
    end
  end
end
