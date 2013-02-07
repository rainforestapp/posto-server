FactoryGirl.define do
  sequence(:facebook_id) { |n| 300000 + n }

  factory :user, aliases: [:recipient_user] do
    facebook_id { generate(:facebook_id) }
  end

  factory :recipient_address do
    recipient_user
    address_api_response

    factory :expired_recipient_address do
      created_at Time.zone.now - 100.days
    end
  end

  factory :address_api_response do
    api_type { :live_address }
    arguments { { text: Faker::Lorem.sentence } }
    response { { street: Faker::Address.street_address(false),
                 state: Faker::Address.state_abbr,
                 zip: Faker::Address.zip_code } }
  end

  factory :api_key do
    user

    factory :expired_api_key do
      expires_at Time.zone.now - 100.days
    end

    factory :renewable_api_key do
      expires_at Time.zone.now + 8.days
    end
  end
end
