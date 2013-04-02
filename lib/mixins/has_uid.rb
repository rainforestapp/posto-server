module HasUid
  extend ActiveSupport::Concern

  included do
    before_save on: :create do
      self.uid = self.class.generate_uid
    end
  end

  module ClassMethods
    def generate_uid
      loop do
        uid = (0..6).to_a.map do
          (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).shuffle[0]
        end.join

        return uid unless self.where(uid: uid).first
      end
    end
  end
end
