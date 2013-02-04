class CardScan < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :app_id, :card_printing_id, :scanned_at
end
