module AuditedStateModel
  extend ActiveSupport::Concern

  module ClassMethods
    def valid_states(*states)
      validates :state, inclusion: { in: states }

      after_initialize do
        self.state ||= states[0]
      end
    end
  end
end
