module HasAuditedState
  extend ActiveSupport::Concern

  module ClassMethods
    def has_audited_state_through(model, params = {})
      as_name = params[:as] || :state

      has_one model, order: "created_at desc"

      self.send(:define_method, as_name) do
        (self.send(model) || self.send("create_#{model}")).state.to_sym
      end

      self.send(:define_method, "#{as_name}=") do |state|
        return if self.send(as_name) == state.to_sym
        self.send("create_#{model}", state: state.to_s)
        state.to_sym
      end
    end
  end
end
