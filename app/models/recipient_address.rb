class RecipientAddress < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :recipient_user_id
end
