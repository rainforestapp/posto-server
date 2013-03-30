class CreditOrder < ActiveRecord::Base
  include AppendOnlyModel

  belongs_to :app
  belongs_to :user
end
