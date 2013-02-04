class UserLogin < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :app_id, :user_id
end
