class CardCollectionEntry < ActiveRecord::Base
  include AppendOnlyModel
  #attr_accessible :app_id, :card_design_id, :source_id, :source_type
end
