class AddressRequestState < ActiveRecord::Base
  include AppendOnlyModel
  include AuditedStateModel

  belongs_to_and_marks_latest_within :address_request
  valid_states :outgoing, :sent, :closed, :expired, :failed
end
