class FacebookTokenState < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :facebook_token_id, :state
end
