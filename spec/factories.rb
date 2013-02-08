FactoryGirl.define do
  sequence(:facebook_id) { |n| 300000 + n }

  factory :app do
    name { Faker::Lorem.word }
  end

  factory :user, 
    aliases: [:recipient_user, :request_sender_user, :request_recipient_user] do
    facebook_id { generate(:facebook_id) }
  end

  factory :address_request do
    request_sender_user
    request_recipient_user
    address_request_medium :facebook_message
    address_request_payload { { message: Faker::Lorem.sentence } }
    app

    factory :expirable_address_request do
      created_at 100.days.ago
    end
  end

  factory :recipient_address do
    recipient_user
    address_api_response
    address_request

    factory :expired_recipient_address do
      created_at 100.days.ago
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
      expires_at 100.days.ago
    end

    factory :renewable_api_key do
      expires_at 8.days.from_now
    end
  end

  factory :stripe_customer do
    user
    stripe_id { Faker::Lorem.characters(32) }
  end

  factory :stripe_card do
    exp_month { Random.new.rand(11) + 1 }
    exp_year { 2020 + Random.new.rand(20) }
    fingerprint { Faker::Lorem.characters(32) }
    last4 { "%04d" % Random.new.rand(9999) }
    card_type { [:amex, :visa, :master, :unknown].sample }

    factory :expired_stripe_card do
      exp_year 2011
    end
  end
end
