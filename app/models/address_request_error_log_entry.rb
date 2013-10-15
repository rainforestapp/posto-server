class AddressRequestErrorLogEntry < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :q
end
