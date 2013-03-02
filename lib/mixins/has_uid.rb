module HasUid
  extend ActiveSupport::Concern

  included do
    before_save on: :create do
      uid = nil

      loop do
        uid = (0..6).to_a.map do
          (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).shuffle[0]
        end.join

        break unless self.class.where(uid: uid).first
      end

      self.uid = uid
    end
  end
end
