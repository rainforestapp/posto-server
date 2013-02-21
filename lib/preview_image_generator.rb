require "image_generator"

class PreviewImageGenerator < ImageGenerator
  def initialize(card_design)
    @card_design = card_design
  end

  def generate!(&block)
    raise "Must set card design" unless @card_design
    raise "Must supply block with one argument" unless block_given? && block.arity == 1

    with_image_for_url(@card_design.composed_full_photo_image.public_url) do |composite|
      with_closed_tempfile do |preview_image_file|
        preview_image = composite.resize(CardImage::CARD_PREVIEW_WIDTH,
                                         CardImage::CARD_PREVIEW_HEIGHT)

        preview_image.write("jpg:#{preview_image_file.path}") do
          self.quality = 80
        end

        yield preview_image_file.path
      end
    end
  end
end
