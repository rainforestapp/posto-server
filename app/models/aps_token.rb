class ApsToken < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :token

  belongs_to :user
  belongs_to :app
end
