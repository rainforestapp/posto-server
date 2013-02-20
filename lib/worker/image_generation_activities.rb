require "postcard_image_generator"

class ImageGenerationActivities
  def generate_preview_images(card_order_id)
    puts "gen preview #{card_order_id}"
  end

  def generate_postcard_images(card_printing_id)
    card_printing = CardPrinting.find(card_printing_id)
    generator = PostcardImageGenerator.new(card_printing)

    generator.generate! do |front_file_path, back_file_path|
      # TODO save to s3
    end
  end
end
