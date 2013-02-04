class CardOrderState < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :card_order_id, :state
end
