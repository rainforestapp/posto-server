class PersonNotificationPreference < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :person_id, :notification_type, :target_id, :enabled
  belongs_to :person

  symbolize :notification_type, in: [:empty_credits], validate: true
end
