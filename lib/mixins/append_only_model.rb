module AppendOnlyModel
  extend ActiveSupport::Concern

  included do
    before_update(lambda do
      raise "Immutable model #{self} trying to be updated"
    end)
  end

  module ClassMethods
    def mark_latest_within_scope(*scope)
      before_create(lambda do
        cols = {}
        scope.each { |col| cols[col] = self[col] }
        self.class.unscoped.where(cols).update_all(latest: false)
        self.latest = true
      end)
    end
  end
end
