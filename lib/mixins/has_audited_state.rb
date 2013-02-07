module HasAuditedState
  extend ActiveSupport::Concern

  module ClassMethods
    def has_audited_state_through(model, params = {})
      as_name = params[:as] || :state

      has_one_audited model

      self.send(:define_method, as_name) do
        (self.send(model) || self.send(model.to_s.pluralize.to_sym).create!).state
      end

      self.send(:define_method, "#{as_name}=") do |state|
        state = state.to_sym
        return if self.send(as_name) == state
        assoc_name = model.to_s.pluralize.to_sym
        self.send(assoc_name).create!(state: state)
        state
      end
    end
  end
end
