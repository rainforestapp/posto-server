module AuditedStateModel
  extend ActiveSupport::Concern

  module ClassMethods
    def valid_states(*states)
      symbolize :state, in: states, default:states[0], validate: true
    end
  end
end
