module HasOneAudited
  extend ActiveSupport::Concern

  module ClassMethods
    def has_one_audited(*args)
      model = args[0]

      options = args.extract_options!
      options.merge!(order: "#{model}_id desc")

      has_many model.to_s.pluralize.to_sym, options

      self.send(:define_method, model.to_sym) do
        self.send(model.to_s.pluralize.to_sym).first
      end
    end
  end
end
