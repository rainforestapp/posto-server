require "image_generator"

class StoryImageGenerator < ImageGenerator
  def initialize(card_order)
    @card_order = card_order
    @card_design = card_order.card_design
  end

  STORY_IMAGE_WIDTH = 480
  STORY_IMAGE_HEIGHT = 480
  INSET = 20

  def generate!(&block)
    raise "Must set card design" unless @card_design
    raise "Must supply block with one argument" unless block_given? && block.arity == 1

    source_url = nil

    if @card_design.app == App.lulcards
      source_url = @card_design.composed_full_photo_image.public_url
    else
      source_url = @card_order.card_printings[0].card_printing_composition.jpg_card_front_image.public_url
    end

    with_image_for_url(source_url) do |composite|
      with_closed_tempfile do |story_image_file|
        w = composite.columns
        h = composite.rows

        aspect = w.to_f / h.to_f

        sh = STORY_IMAGE_HEIGHT - (INSET * 2)
        sw = (sh * aspect)

        story_card = composite.resize(sw,sh)

        begin
          story_image = Magick::Image.new(STORY_IMAGE_WIDTH, STORY_IMAGE_HEIGHT)

          begin
            story_draw = Magick::Draw.new
            card_x = (STORY_IMAGE_WIDTH / 2.0) - (sw / 2.0)

            if @card_design.app == App.lulcards
              story_draw.fill('black')
              story_draw.rectangle(0,0,STORY_IMAGE_WIDTH,STORY_IMAGE_HEIGHT)
            end

            background_image = Magick::Image.read("resources/images/#{@card_design.app.name}_story_background.png").first

            begin
              background = story_draw.pattern("hatch", 0, 0, background_image.columns, background_image.rows) do
                story_draw.composite(0,0,0,0,background_image)
              end

              story_draw.fill("hatch")
              story_draw.rectangle(0,0,card_x - INSET,STORY_IMAGE_HEIGHT)
              story_draw.rectangle(STORY_IMAGE_WIDTH - card_x + INSET,0,STORY_IMAGE_WIDTH,STORY_IMAGE_HEIGHT)
              story_draw.draw(story_image)

              story_image.composite!(story_card,card_x,INSET,Magick::OverCompositeOp)

              story_image.write("png:#{story_image_file.path}")

              yield story_image_file.path
            ensure
              background_image.destroy!
            end
          ensure
            story_image.destroy!
          end
        ensure
          story_card.destroy!
        end
      end
    end
  end
end
