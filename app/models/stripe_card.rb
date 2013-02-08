class StripeCard < ActiveRecord::Base
  include AppendOnlyModel

  symbolize :card_type, in: [:visa, :amex, :master, :discover, :jcb, :diners, :unknown], validates: true

  def active?
    !self.expired?
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
