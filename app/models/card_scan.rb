class CardScan < ActiveRecord::Base
  include AppendOnlyModel
  attr_accessible :app_id, :card_printing_id, :scanned_at, :scan_position, :device_uuid, :scanned_by_user_id

  symbolize :scan_position, in: [:front, :back], validate: true

  belongs_to :app
  belongs_to_and_marks_latest_within :card_printing
  belongs_to :scanned_by_user, class_name: "User"

  def send_notification!
    order_sender = self.card_printing.card_order.order_sender_user
    profile = self.card_printing.recipient_user.user_profile

    if profile
      message = "The card you sent #{profile.name} has been scanned."

      if self.scanned_by_user == self.card_printing.recipient_user &&
        profile = self.card_printing.recipient_user.user_profile
        message = "#{profile.name} just scanned the card you sent #{profile.direct_object_pronoun}."
      end

      order_sender.send_notification(message, app: self.app)
    end
  end
end
