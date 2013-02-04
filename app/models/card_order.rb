class CardOrder < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :app_id, :sender_user_id
end
