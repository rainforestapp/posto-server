class FacebookToken < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :token, :user_id
end
