class CreditOrder < ActiveRecord::Base
  include AppendOnlyModel
  include TransactionRetryable

  attr_accessible :app_id, :credits, :price, :gifter_person_id, :note

  belongs_to :app
  belongs_to :user
  belongs_to :gifter_person, class_name: "Person"

  def printable_total_price
    "$%.02f" % (price / 100.0) 
  end

  def is_gift?
    !!self.gifter_person
  end

  def orderer_name
    if is_gift?
      self.gifter_person.try(:person_profile).try(:name)
    else
      self.user.try(:user_profile).try(:name)
    end
  end

  def orderer_email
    if is_gift?
      self.gifter_person.email
    else
      self.user.try(:user_profile).try(:email)
    end
  end

  def recipient_name
    self.user.try(:user_profile).try(:name)
  end

  def recipient_email
    self.user.try(:user_profile).try(:email)
  end

  def order_number
    10000 + (self.credit_order_id * 17)
  end
end
