module AppendOnlyModel
  extend ActiveSupport::Concern

  included do
    before_update(lambda do
      raise "Immutable model #{self} trying to be updated" unless @_saving_metadata
    end)

    serialize :meta, ActiveRecord::Coders::Hstore
  end

  def append_to_metadata!(new_metadata)
    current_metadata = self.meta || {}
    @_saving_metadata = true
    self.meta = current_metadata.merge(new_metadata)
    self.save
    @_saving_metadata = false
    self.meta
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
