module HasAppendOnly
  extend ActiveSupport::Concern

  module ClassMethods
    def has_append_only(model)
      has_many model.to_s.pluralize.to_sym, :order => "created_at desc"

      self.send(:define_method, model.to_sym) do
        self.send(model.to_s.pluralize.to_sym).first
      end
    end
  end
end
