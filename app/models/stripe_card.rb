class StripeCard < ActiveRecord::Base
  include AppendOnlyModel

  attr_accessible :fingerprint, :last4, :card_type, :exp_month, :exp_year

  symbolize :card_type, in: [:visa, :amex, :master, :discover, :jcb, :diners, :unknown], validates: true

  CARD_TYPE_MAP = {
    "Visa" => :visa,
    "American Express" => :amex,
    "MasterCard" => :master,
    "Discover" => :discover,
    "JCB" => :jcb,
    "Diners Club" => :diners
  }

  def self.find_or_create_by_stripe_card_info(card_info)
    StripeCard.where(fingerprint: card_info["fingerprint"]).first_or_create!(
      fingerprint: card_info["fingerprint"],
      last4: card_info["last4"],
      card_type: CARD_TYPE_MAP[card_info["type"]] || :unknown,
      exp_month: card_info["exp_month"],
      exp_year: card_info["exp_year"]
    )
  end

  def expired?
    Time.zone.now >= first_bad_date
  end

  private 

  def first_bad_date
    first_bad_month = (self.exp_month % 12) + 1
    first_bad_year = self.exp_year
    first_bad_year += 1 if first_bad_month == 1
    DateTime.new(first_bad_year, first_bad_month, 1)
  end
end
