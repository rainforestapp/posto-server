class PostcardSubject < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited
  include TransactionRetryable

  attr_accessible :user_id, :app_id, :birthday, :name, :postcard_subject_type, :gender

  belongs_to :user
  belongs_to :app
  symbolize :postcard_subject_type, in: [:child, :baby], validates: true

  has_audited_state_through :postcard_subject_state
end
