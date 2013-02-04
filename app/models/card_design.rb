class CardDesign < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :app_id, :author_user_id, :bottom_caption, :bottom_caption_font_size, :design_type, :edited_photo_image_id, :editied_full_photo_image_id, :original_full_photo_image_id, :original_photo_image_id, :printable_full_image_id, :printable_image_id, :source_card_design_id, :top_caption, :top_caption_font_size
end
