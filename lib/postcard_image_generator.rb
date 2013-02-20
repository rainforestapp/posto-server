require "tempfile"
require "open-uri"
require "uri"

class PostcardImageGenerator
  BORDER_SIZE = 0.05
  QR_PATH = "http://lulcards.com/s/"

  attr_accessor :card_printing

  def generate_into!(output_front_image_path, output_back_image_path)
    raise "Must set card printing" unless self.card_printing

    card_order = self.card_printing.card_order
    card_design = self.card_order.card_design

    template_path = "resources/postcards/#{card_design.design_type.to_s.gsub("_", "/")}"
    front_scan_key = self.card_printing.front_scan_key
    back_scan_key = self.card_printing.back_scan_key
    sender_user = self.card_order.order_sender_user
    fb_name = sender_user.user_profile.name
    sent_date = self.card_order.created_at.strftime("%-m/%-d/%y")
    sent_text = "Sent on #{sent_date}"

    composed_image_url = card_design.composed_full_photo_image.public_url

    with_file_for_url(composed_image_url) do |composite_file|
      profile_image_url = "https://graph.facebook.com/#{sender_user.facebook_id}/picture?width=200&height=200"

      with_file_for_url(profile_image_url) do |profile_image_file|
        with_closed_tempfile do |back_qr_file|
          with_closed_tempfile do |front_qr_file|
            with_closed_tempfile do |front_image_file|
              with_closed_tempfile do |back_image_file|
                composite = Magick::Image.read(composite_file.path).first
                cols = composite.columns
                rows = composite.rows

                border_pixels = (BORDER_SIZE * [cols, rows].max.to_f).floor

                front_template = Magick::Image.read(template_path + "/FrontTemplate.png").first
                back = Magick::Image.read(template_path + "/BackTemplate.png").first

                front_qr = RQRCode::QRCode.new(URI.escape(QR_PATH + front_scan_key), size: 4, level: :h)
                front_qr_png = front_qr.to_img.resize(150,150).save(front_qr_file.path)
                front_qr_image = Magick::Image.read(front_qr_file.path).first
                front_template.composite!(front_qr_image, 1594, 97, Magick::DstOverCompositeOp)

                front = composite.resize_to_fill(front_template.rows, front_template.columns)
                front.rotate!(270)
                wallet_card = composite.rotate(270)
                wallet_card.resize_to_fill!(1050, 750)
                front.composite!(front_template, 0, 0, Magick::OverCompositeOp)

                back_qr = RQRCode::QRCode.new(URI.escape(QR_PATH + back_scan_key), size: 4, level: :h)
                back_qr_png = back_qr.to_img.resize(150,150).save(back_qr_file.path)
                back_qr_image = Magick::Image.read(back_qr_file.path).first

                fb_profile = Magick::Image.read(profile_image_file.path).first
                fb_profile.resize_to_fill!(150,150)

                back.composite!(wallet_card, 20, 20, Magick::DstOverCompositeOp)
                back.composite!(back_qr_image, 94, 811, Magick::DstOverCompositeOp)
                back.composite!(fb_profile, 1135, 576, Magick::OverCompositeOp)

                back_with_text = Magick::Draw.new

                use_big_font = fb_name.size <= 20
                name_y_offset = use_big_font ? 620 : 610
                sent_y_offset = use_big_font ? 660 : 650

                back_with_text.annotate(back, 0, 0, 1310, name_y_offset, fb_name) do
                  self.fill = "#FFFFFF"
                  self.stroke = 'transparent'
                  self.pointsize = use_big_font ? 48 : 32
                  self.font_family = "HelveticaNeueL"
                  self.text_align(Magick::LeftAlign)
                end

                back_with_text.annotate(back, 0, 0, 1310, sent_y_offset, sent_text) do
                  self.fill = "#FC933E"
                  self.stroke = 'transparent'
                  self.pointsize = 28
                  self.font_family = "HelveticaNeueL"
                  self.text_align(Magick::LeftAlign)
                end

                front.write("png:" + front_image_file.path)
                back.write("png:" + back_image_file.path)

                front_pdf = Magick::Image.read(front_image_file.path).first
                back_pdf = Magick::Image.read(back_image_file.path).first

                [front_pdf, back_pdf].each do |img|
                  img.add_profile("resources/icc/sRGB_v4_ICC_preference.icc")
                  img.add_profile("resources/icc/USWebUncoated.icc")
                  img.colorspace = Magick::CMYKColorspace
                end

                front_pdf.write("pdf:#{output_front_image_path}")
                back_pdf.write("pdf:#{output_back_image_path}")
              end
            end
          end
        end
      end
    end
  end

  def with_file_for_url(url, *args)
    with_tempfile(*args) do |file|
      open(url) do |data|
        file.write(data.read)
        file.close
        yield file
      end
    end
  end

  def with_closed_tempfile(*args)
    with_tempfile(*args) do |file|
      file.close
      yield(file)
    end
  end

  def with_tempfile(*args)
    options = args.extract_options!

    Tempfile.open(SecureRandom.hex) do |file|
      file.binmode
      yield(file)
    end
  end
end
