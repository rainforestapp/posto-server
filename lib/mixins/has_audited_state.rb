module HasAuditedState
  extend ActiveSupport::Concern

  module ClassMethods
    def has_audited_state_through(model, params = {})
      as_name = params[:as] || :state

      has_one_audited model

      self.send(:define_method, as_name) do
        current_state_model = self.send(model)

        if current_state_model
          current_state_model.state
        else
          Kernel.const_get(model.to_s.camelize).get_state_values[0][1]
        end
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
