module HasAuditedState
  extend ActiveSupport::Concern

  module ClassMethods
    def has_audited_state_through(model, params = {})
      as_name = params[:as] || :state

      has_append_only model

      self.send(:define_method, as_name) do
        (self.send(model) || self.send(model.to_s.pluralize.to_sym).create!).state.to_sym
      end

      self.send(:define_method, "#{as_name}=") do |state|
        return if self.send(as_name) == state.to_sym
        assoc_name = model.to_s.pluralize.to_sym
        self.send(assoc_name).create!(state: state.to_sym)
        state.to_sym
      end
    end
  end
end
