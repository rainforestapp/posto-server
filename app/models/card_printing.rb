class CardPrinting < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :card_order_id, :print_number, :printed_image_id, :recipient_user_id
end
