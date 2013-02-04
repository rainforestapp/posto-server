class CardScanAuthor < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :author_user_id, :card_scan_id
end
