class RecipientAddress < ActiveRecord::Base
  include AppendOnlyModel
  
  attr_accessible :address_api_response, :address_request

  belongs_to_and_marks_latest_within :recipient_user, class_name: "User"

  belongs_to :address_api_response
  belongs_to :address_request

  def expired?
    Time.zone.now > expires_at
  end

  def up_to_date?
    !expired?
  end

  def expires_at
    self.created_at + CONFIG.recipient_address_expiration_days.days
  end

  def api_data
    self.address_api_response.response
  end

  def delivery_line_1
    api_data["delivery_line_1"]
  end

  def delivery_line_2
    api_data["delivery_line_2"]
  end

  def city
    api_data["components"]["city_name"]
  end

  def state
    api_data["components"]["state_abbreviation"]
  end

  def zip
    if api_data["components"]["plus4_code"]
      api_data["components"]["zipcode"] + "-" + api_data["components"]["plus4_code"]
    else
      api_data["components"]["zipcode"]
    end
  end

  def printable_address
    address_api_response.printable_address
  end
end
