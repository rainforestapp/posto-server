class CardPrinting < ActiveRecord::Base
  include AppendOnlyModel
  include HasAuditedState
  include HasOneAudited

  attr_accessible :recipient_user

  belongs_to :card_order
  belongs_to :recipient_user, class_name: "User"

  before_save(on: :create) do
    self.print_number = self.class.connection.select_value <<-END
      select nextval('card_printing_print_number_seq'::regclass)
    END
  end

  has_audited_state_through :card_printing_state
end
