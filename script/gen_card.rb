#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + "/../config/environment.rb")
require "rmagick"

BORDER_SIZE = 0.05

template_path = "resources/postcards/lulcards/1"
composite_file = "composite.jpg"
front_scan_key = "jfsiFkdsuvD"
back_scan_key = "fKdiBfkAjfod"
qr_path = "http://lulcards.com/s/"
# http://graph.facebook.com/id/picture?width=200&height=200
fb_profile_file = "sender_fb_profile.jpg"
fb_name = "Greg Fodor"
sent_text = "Sent on 2/3/13"

composite = Magick::Image.read(composite_file).first
cols = composite.columns
rows = composite.rows

border_pixels = (BORDER_SIZE * [cols, rows].max.to_f).floor

#cropped_front_composite = composite.crop(border_pixels, 
#                                         border_pixels,
#                                         cols - (2 * border_pixels),
#                                         rows - (2 * border_pixels))
#
#cropped_front_composite.write("cropped_front_composite.jpg")

front_template = Magick::Image.read(template_path + "/FrontTemplate.png").first
back_template = Magick::Image.read(template_path + "/BackTemplate.png").first

front_qr = RQRCode::QRCode.new(qr_path + front_scan_key, size: 4, level: :h)
front_qr_png = front_qr.to_img.resize(150,150).save("front_qr.png")
front_qr_image = Magick::Image.read("front_qr.png").first
front_template.composite!(front_qr_image, 1594, 97, Magick::DstOverCompositeOp)

front = composite.resize_to_fill(front_template.rows, front_template.columns)
front.rotate!(270)
wallet_card = composite.rotate(270)
wallet_card.resize_to_fill!(1050, 750)
front.composite!(front_template, 0, 0, Magick::OverCompositeOp)

back_qr = RQRCode::QRCode.new(qr_path + back_scan_key, size: 4, level: :h)
back_qr_png = back_qr.to_img.resize(150,150).save("back_qr.png")
back_qr_image = Magick::Image.read("back_qr.png").first

fb_profile = Magick::Image.read(fb_profile_file).first
fb_profile.resize_to_fill!(150,150)

back_template.composite!(wallet_card, 20, 20, Magick::DstOverCompositeOp)
back_template.composite!(back_qr_image, 94, 811, Magick::DstOverCompositeOp)
back_template.composite!(fb_profile, 1135, 576, Magick::OverCompositeOp)

back_with_text = Magick::Draw.new

use_big_font = fb_name.size <= 20
name_y_offset = use_big_font ? 620 : 610
sent_y_offset = use_big_font ? 660 : 650

back_with_text.annotate(back_template, 0, 0, 1310, name_y_offset, fb_name) do
  self.fill = "#FFFFFF"
  self.stroke = 'transparent'
  self.pointsize = use_big_font ? 48 : 32
  self.font_family = "HelveticaNeueL"
  self.text_align(Magick::LeftAlign)
end

back_with_text.annotate(back_template, 0, 0, 1310, sent_y_offset, sent_text) do
  self.fill = "#FC933E"
  self.stroke = 'transparent'
  self.pointsize = 28
  self.font_family = "HelveticaNeueL"
  self.text_align(Magick::LeftAlign)
end

front.write("front_rgb.png")
back_template.write("back_rgb.png")

`rm front_qr.png`
`rm back_qr.png`

# CMYK at end
#`convert front_rgb.png -profile srgb.icc -profile USWebUncoated.icc front.jpg`
#`convert back_rgb.png -profile srgb.icc -profile USWebUncoated.icc back.jpg`
#`rm front_rgb.png`
#`rm back_rgb.png`
