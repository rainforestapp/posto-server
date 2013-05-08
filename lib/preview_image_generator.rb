require "image_generator"

class PreviewImageGenerator < ImageGenerator
  def initialize(card_design)
    @card_design = card_design
  end

  def generate!(&block)
    raise "Must set card design" unless @card_design
    raise "Must supply block with one argument" unless block_given? && block.arity == 2

    with_image_for_url(@card_design.composed_full_photo_image.public_url) do |composite|
      with_closed_tempfile do |preview_image_file|
        with_closed_tempfile do |treated_image_file|
          w = CardImage::CARD_PREVIEW_WIDTH
          h = CardImage::CARD_PREVIEW_HEIGHT
          preview_image = composite.resize(w,h)

          begin
            preview_image.write("jpg:#{preview_image_file.path}") do
              self.quality = 80
            end

            bw = 20
            hbw = 10

            treated_image = Magick::Draw.new
            
            unless @card_design.app == App.babygrams
              treated_image.stroke_width(bw)
              treated_image.stroke('white')
              treated_image.line(-hbw,hbw,w+hbw,hbw)
              treated_image.line(hbw,-hbw,hbw,h+hbw)
              treated_image.line(-hbw,h-hbw,w+hbw,h-hbw)
              treated_image.line(w-hbw,hbw,w-hbw,h+hbw)
              treated_image.stroke_width(1)
              treated_image.stroke('gray')
              treated_image.line(bw,bw,w-bw,bw)
              treated_image.line(bw,bw,bw,h-bw)
              treated_image.line(w-bw,bw,w-bw,h-bw)
              treated_image.line(bw,h-bw,w-bw,h-bw)
              treated_image.draw(preview_image)
            end

            #gloss = Magick::Image.new(w, h, Magick::GradientFill.new(0, h * 2, w * 2, 0, "rgba(88%,88%,88%,100%)", "rgba(33%,33%,33%,0%)"))

            #preview_image.composite!(gloss,0,0,Magick::OverlayCompositeOp)

            preview_image.write("jpg:#{treated_image_file.path}") do
              self.quality = 80
            end

            yield preview_image_file.path, treated_image_file.path
          ensure
            preview_image.destroy!
          end
        end
      end
    end
  end
end
