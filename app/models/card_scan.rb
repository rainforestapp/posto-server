class CardScan < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :app_id, :card_printing_id, :scanned_at, :scan_position, :device_uuid

  symbolize :scan_position, in: [:front, :back], validate: true
end
