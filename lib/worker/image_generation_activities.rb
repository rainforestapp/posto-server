require "preview_image_generator"
require "postcard_image_generator"

class ImageGenerationActivities
  def generate_preview_images(card_order_id)
    card_order = CardOrder.find(card_order_id)
    card_design = card_order.card_design
    card_design_author = card_design.author_user
    generator = PreviewImageGenerator.new(card_design)
    app = card_order.app

    generator.generate! do |preview_file_path, treated_preview_file_path|
      preview_image = card_design_author.create_and_publish_image_file!(preview_file_path, app: app, image_type: :card_preview)
      treated_preview_image = card_design_author.create_and_publish_image_file!(treated_preview_file_path, app: app, image_type: :treated_card_preview)

      card_design.card_preview_compositions.create!(
        card_preview_image: preview_image,
        treated_card_preview_image: treated_preview_image
      )
    end

    true
  end

  def generate_postcard_images(card_printing_id)
    card_printing = CardPrinting.find(card_printing_id)
    generator = PostcardImageGenerator.new(card_printing)
    card_design_author = card_printing.card_design.author_user
    app = card_printing.card_order.app

    generator.generate! do |front_file_path, back_file_path|
      front_image = card_design_author.create_and_publish_image_file!(front_file_path, app: app, image_type: :card_front)
      back_image = card_design_author.create_and_publish_image_file!(back_file_path, app: app, image_type: :card_back)

      card_printing.card_printing_compositions.create!(
        card_front_image: front_image,
        card_back_image: back_image
      )
    end

    true
  end
end
