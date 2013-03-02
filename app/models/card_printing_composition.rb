class CardPrintingComposition < ActiveRecord::Base
  include AppendOnlyModel
  include HasOneAudited

  attr_accessible :card_front_image, :card_back_image, :jpg_card_front_image, :jpg_card_back_image

  belongs_to :card_front_image, class_name: "CardImage"
  belongs_to :card_back_image, class_name: "CardImage"
  belongs_to :jpg_card_front_image, class_name: "CardImage"
  belongs_to :jpg_card_back_image, class_name: "CardImage"

  belongs_to_and_marks_latest_within :card_printing
end
