module AppendOnlyModel
  extend ActiveSupport::Concern

  included do
    before_update(lambda do
      raise "Immutable model #{self} trying to be updated"
    end)
  end

  module ClassMethods
    def belongs_to_and_marks_latest_within(*args)
      assoc = self.belongs_to(*args)
      mark_latest_within_scope(assoc.foreign_key)
    end

    def mark_latest_within_scope(*scope)
      # http://pivotallabs.com/activerecord-callbacks-autosave-before-this-and-that-etc-/
      before_save(on: :create) do
        self.class.unscoped.where(self.attributes.slice(*scope)).update_all(latest: false)
        self.latest = true
      end
    end
  end
end
