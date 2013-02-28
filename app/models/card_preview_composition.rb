class CardPreviewComposition < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  attr_accessible :card_preview_image, :treated_card_preview_image

  belongs_to :card_preview_image, class_name: "CardImage"
  belongs_to :treated_card_preview_image, class_name: "CardImage"

  belongs_to_and_marks_latest_within :card_design
end
