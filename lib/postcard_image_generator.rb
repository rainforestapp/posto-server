require "date_helper"
require "image_generator"

class PostcardImageGenerator < ImageGenerator
  BORDER_SIZE = 0.05
  MAX_RECIPIENTS_TO_LIST = 4

  def initialize(card_printing)
    @card_printing = card_printing
  end

  def generate!(&block)
    raise "Must set card printing" unless @card_printing
    raise "Must supply block with four arguments" unless block_given? && block.arity == 4

    card_order = @card_printing.card_order
    card_design = card_order.card_design
    app = card_design.app

    CONFIG.for_app(app) do |config|
      template_path = "resources/postcards/#{card_design.design_type.to_s.gsub("_", "/")}"
      front_scan_key = @card_printing.front_scan_key
      back_scan_key = @card_printing.back_scan_key
      sender_user = card_order.order_sender_user
      fb_name = sender_user.user_profile.name
      sent_date = card_order.created_at.strftime("%-m/%-d/%y")
      sent_text = "Sent on #{sent_date}"

      other_recipients = card_order.card_printings.reject { |p| p == @card_printing || !p.mailable? }.map { |p| p.recipient_user }

      if other_recipients.size > 0
        recipients_to_list = other_recipients[0..(MAX_RECIPIENTS_TO_LIST - 1)]
        names = recipients_to_list.map { |r| r.user_profile.name }

        if other_recipients.size > MAX_RECIPIENTS_TO_LIST
          extra_recipient_count = other_recipients.size - MAX_RECIPIENTS_TO_LIST

          if extra_recipient_count == 1
            names << "1 other"
          else
            names << "#{extra_recipient_count} others"
          end
        else
          names << "you"
        end

        sent_text += " to #{names.to_sentence}."
      end

      title_on_top = card_design.top_caption.size < card_design.bottom_caption.size
      draw_credits_nag = @card_printing.should_draw_credits_nag?
      render_qr_on_front = false

      #if card_design.top_caption.size > 0 && card_design.bottom_caption.size > 0
      #  render_qr_on_front = false
      #  title_on_top = false
      #end

      composed_image_url = card_design.composed_full_photo_image.public_url
      profile_image_url = sender_user.profile_image_url(true)

      front_file = nil
      back_file = nil

      if card_design.app == App.babygrams
        frame = card_design.frame_type || "grey"
        front_file = template_path + "/frames/frame_#{frame}.png"
        prefix = "Blue"

        if card_design.postcard_subject && card_design.postcard_subject[:gender] == "girl"
          prefix = "Pink"
        end

        back_file = template_path + "/#{prefix}BackTemplate#{draw_credits_nag ? "CreditsNag" : ""}.png"
        title_on_top = false
      else
        front_file = template_path + "/FrontTemplate#{render_qr_on_front ? (title_on_top ? "Flipped" : "") : (title_on_top ? "FlippedCodeless.png" : "Codeless.png")}"
        back_file = template_path + "/BackTemplate.png"
      end

      with_closed_tempfile do |front_pdf_file|
        with_closed_tempfile do |back_pdf_file| 
          with_closed_tempfile do |front_jpg_image_file|
            with_closed_tempfile do |back_jpg_image_file| 
              with_image_for_url(composed_image_url) do |composite|
                with_image_for_url(profile_image_url) do |fb_profile|
                  fb_profile.resize_to_fill!(150,150)

                  with_closed_tempfile do |back_qr_file|
                    with_closed_tempfile do |front_qr_file|
                      with_closed_tempfile do |front_image_file|
                        with_closed_tempfile do |back_image_file|
                          with_image(front_file) do |front_template|
                            with_image(back_file) do |back|
                              cols = composite.columns
                              rows = composite.rows

                              front_template.rotate!(270) if app == App.babygrams

                              front_qr = RQRCode::QRCode.new(URI.escape(config.qr_path + front_scan_key), size: 4, level: :h)
                              front_qr_png = front_qr.to_img.resize(175,175).save(front_qr_file.path)
                              back_qr = RQRCode::QRCode.new(URI.escape(config.qr_path + back_scan_key), size: 4, level: :h)
                              back_qr_png = back_qr.to_img.resize(175,175).save(back_qr_file.path)

                              with_image(front_qr_file.path) do |front_qr_image|
                                with_image(back_qr_file.path) do |back_qr_image|
                                  if render_qr_on_front
                                    front_template.composite!(front_qr_image, 1569, 97, Magick::DstOverCompositeOp)
                                  end

                                  front = composite.resize_to_fill(front_template.rows, front_template.columns)

                                  begin
                                    front.rotate!(title_on_top ? 90 : 270)
                                    wallet_card = composite.rotate(270)
                                    wallet_card.resize_to_fill!(1050, 750)
                                    
                                    if app == App.babygrams
                                      # Move it inside for the babygram frame
                                      resized_front = composite.resize_to_fill(front_template.rows - 44, front_template.columns - 44)
                                      resized_front.rotate!(title_on_top ? 90 : 270)
                                      front.composite!(resized_front, 22, 22, Magick::OverCompositeOp)
                                      resized_front.try(:destroy!)
                                    end

                                    front.composite!(front_template, 0, 0, Magick::OverCompositeOp)

                                    if app == App.babygrams
                                      if card_design.postcard_subject && card_design.postcard_subject[:name]
                                        draw_subject(card_design, front)
                                      end
                                    end

                                    back.composite!(wallet_card, 20, 20, Magick::DstOverCompositeOp)
                                    back.composite!(back_qr_image, 94, 811, Magick::DstOverCompositeOp)
                                    back.composite!(fb_profile, 1135, 576, Magick::OverCompositeOp)

                                    back_with_text = Magick::Draw.new

                                    use_big_font = fb_name.size <= 20
                                    name_y_offset = use_big_font ? 620 : 610
                                    sent_y_offset = use_big_font ? 660 : 650

                                    back_with_text.fill = "#FFFFFF"
                                    back_with_text.stroke = 'transparent'
                                    back_with_text.pointsize = use_big_font ? 48 : 32

                                    back_with_text.font("'#{Rails.root}/resources/fonts/HelveticaNeueCondensedBold.ttf'")

                                    if app == App.babygrams
                                      back_with_text.font("'#{Rails.root}/resources/fonts/vagrounded-bold.ttf'")
                                    end

                                    back_with_text.text_align(Magick::LeftAlign)
                                    back_with_text.text(1310, name_y_offset, fb_name)
                                    back_with_text.draw(back)

                                    if app == App.babygrams && draw_credits_nag
                                      draw_credits_nag(back)
                                    end

                                    sent_text_line_offset = 0

                                    word_wrap(sent_text, 35).split(/\n/).each do |line|
                                      back_with_text.annotate(back, 550, 0, 1310, sent_y_offset + sent_text_line_offset, line) do
                                        self.fill = "#FF8E32"

                                        if app == App.babygrams
                                          self.fill = "#EEEEEE"
                                        end

                                        self.stroke = 'transparent'
                                        self.pointsize = 28
                                        self.text_align(Magick::LeftAlign)
                                      end

                                      sent_text_line_offset += 32
                                    end

                                    add_note(card_design, back)

                                    back_with_text.annotate(back, 0, 0, 100, 1228, @card_printing.card_number) do
                                      self.fill = "#AAAAAA"

                                      if app == App.babygrams
                                        self.fill = "#EEEEEE"
                                      end

                                      self.stroke = 'transparent'
                                      self.pointsize = 32
                                      self.text_align(Magick::LeftAlign)
                                    end

                                    front.write("png:" + front_image_file.path)
                                    back.write("png:" + back_image_file.path)

                                    with_image(front_image_file.path) do |front_pdf|
                                      with_image(back_image_file.path) do |back_pdf|

                                        if title_on_top
                                          front_pdf.rotate!(270)
                                        else
                                          front_pdf.rotate!(90)
                                        end

                                        front_pdf.write("jpeg:#{front_jpg_image_file.path}") do
                                          self.quality = 90
                                        end

                                        if title_on_top
                                          front_pdf.rotate!(90)
                                        else
                                          front_pdf.rotate!(270)
                                        end

                                        back_pdf.write("jpeg:#{back_jpg_image_file.path}") do
                                          self.quality = 90
                                        end

                                        [front_pdf, back_pdf].each do |img|
                                          img.add_profile("resources/icc/sRGB_v4_ICC_preference.icc")
                                          img.add_profile("resources/icc/USWebUncoated.icc")
                                          img.colorspace = Magick::CMYKColorspace
                                          img.x_resolution = 300.0
                                          img.y_resolution = 300.0
                                        end

                                        front_pdf.write("pdf:#{front_pdf_file.path}")
                                        back_pdf.write("pdf:#{back_pdf_file.path}")

                                        yield(front_pdf_file.path, back_pdf_file.path,
                                              front_jpg_image_file.path, back_jpg_image_file.path)
                                      end
                                    end
                                  ensure
                                    front.try(:destroy!)
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def draw_subject(card_design, front)
    drew_age = false

    draw = Magick::Draw.new
    draw.fill = "#FFFFFF"
    draw.stroke = '#B8B8B8'
    draw.stroke_width = 2
    draw.roundrectangle(1600,395,1600 + 146,395 + 530,14,14)
    draw.draw(front)

    birthday = card_design.postcard_subject[:birthday]

    if birthday
      birthday = Chronic.parse(birthday)
      photo_taken_at = card_design.photo_taken_at

      if photo_taken_at && photo_taken_at > birthday
        age = DateHelper.printable_age(photo_taken_at, birthday)

        if age
          drew_age = true
          draw = Magick::Draw.new
          draw.fill = "#A8A8A8"
          draw.stroke = 'transparent'
          draw.pointsize = 38
          draw.font("'#{Rails.root}/resources/fonts/vagrounded-bold.ttf'")
          draw.text_align(Magick::CenterAlign)
          draw.rotate(270)
          draw.text(-660, 1720, "#{age} old")
          draw.draw(front)
        end
      end
    end

    name = card_design.postcard_subject[:name]
    draw = Magick::Draw.new
    draw.fill = "#686868"
    draw.stroke = 'transparent'

    if name.size > 22
      draw.pointsize = 36
    elsif name.size > 18
      draw.pointsize = 48
    else
      draw.pointsize = 56
    end

    draw.font("'#{Rails.root}/resources/fonts/vagrounded-bold.ttf'")
    draw.text_align(Magick::CenterAlign)
    draw.rotate(270)
    draw.text(-660, drew_age ? 1668 : 1688, name)
    draw.draw(front)
  end

  def word_wrap(text, columns = 80)
    text.split("\n").collect do |line|
      line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
  end

  def add_note(card_design, back)
    note = card_design.note || ""
    return unless note.size > 0

    note = note[0..CONFIG.note_max_length]

    note_offset = 0

    draw = Magick::Draw.new

    draw.fill = "#FFFFFF"
    draw.stroke = 'transparent'
    draw.roundrectangle(1110,280,1110+655,280+200,12,12)
    draw.draw(back)

    draw = Magick::Draw.new

    word_wrap(note, 34).split(/\n/).each do |line|
      draw.fill = "#444444"
      draw.stroke = 'transparent'
      draw.pointsize = 34
      draw.font("'#{Rails.root}/resources/fonts/RobotoSlab-Regular.ttf'")
      draw.text_align(Magick::LeftAlign)
      draw.text(1134, 330 + note_offset, line)
      draw.draw(back)

      note_offset += 41
    end
  end

  def draw_credits_nag(back)
    card_order = @card_printing.card_order
    sender_user = card_order.order_sender_user

    draw = Magick::Draw.new
    draw.stroke = 'transparent'
    draw.fill = "#ffffff"
    draw.pointsize = 42

    draw.font("'#{Rails.root}/resources/fonts/vagrounded-bold.ttf'")
    draw.text_align(Magick::LeftAlign)

    if sender_user.user_profile.first_name.size >= 8
      draw.text(122, 846, "Like this? Send #{sender_user.user_profile.first_name} a thank you:")
    else
      draw.text(122, 846, "Like this? Send #{sender_user.user_profile.first_name} a thank-you-note:")
    end

    draw.draw(back)

    draw = Magick::Draw.new
    draw.stroke = 'transparent'
    draw.fill = "#000000"
    draw.pointsize = 48 
    draw.font("'#{Rails.root}/resources/fonts/RobotoSlab-Regular.ttf'")
    draw.text_align(Magick::CenterAlign)
    draw.text(575, 1022, "#{@card_printing.lookup_number}")
    draw.draw(back)
  end
end
