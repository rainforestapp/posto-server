class CardDesign < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  attr_accessible :app, :author_user, 
                  :bottom_caption, :bottom_caption_font_size, 
                  :top_caption, :top_caption_font_size,
                  :design_type, 
                  :original_full_photo_image, :edited_full_photo_image, :composed_full_photo_image, 
                  :source_card_design_id, :stock_design_id, :note, :photo_is_user_generated,
                  :postcard_subject_json, :frame_type, :photo_taken_at,
                  :author_user_id, :app_id, :original_full_photo_image_id,
                  :composed_full_photo_image_id, :edited_full_photo_image_id

  belongs_to :app
  belongs_to :author_user, class_name: "User"
  belongs_to :original_full_photo_image, class_name: "CardImage"
  belongs_to :edited_full_photo_image, class_name: "CardImage"
  belongs_to :composed_full_photo_image, class_name: "CardImage"
  belongs_to :source_card_design, class_name: "CardDesign"
  has_many :card_orders

  has_one_audited :card_preview_composition

  symbolize :design_type, in: [:lulcards_alpha, :babygrams_alpha], validates: true

  def postcard_subject
    return {} unless self.postcard_subject_json

    JSON.parse(self.postcard_subject_json).tap do |postcard_subject|
      postcard_subject.symbolize_keys!
    end
  end
end
