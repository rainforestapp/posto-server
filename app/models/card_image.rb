class CardImage < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :app, :uuid, :width, :height, :orientation, :image_type

  belongs_to :author_user, class_name: "User"
  belongs_to :app

  symbolize :image_type, 
            in: [:original_full_photo, :edited_full_photo, :composed_full_photo, :card_front, :card_back],
            validates: true

  symbolize :orientation, 
            in: [:up, :down, :left, :right, 
                 :up_mirrored, :down_mirrored, :left_mirrored, :right_mirrored],
            validates: true
end
