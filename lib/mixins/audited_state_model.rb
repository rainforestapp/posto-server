module AuditedStateModel
  extend ActiveSupport::Concern

  module ClassMethods
    def valid_states(*states)
      attr_accessible :state
      symbolize :state, in: states, default:states[0], validate: true
    end
  end
end
