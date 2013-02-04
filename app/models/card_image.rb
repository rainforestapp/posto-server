class CardImage < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :app_id, :author_user_id, :uuid, :height, :image_type, :orientation, :width
end
