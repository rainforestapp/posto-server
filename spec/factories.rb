FactoryGirl.define do
  sequence(:facebook_id) { |n| 300000 + n }

  factory :user do
    facebook_id { generate(:facebook_id) }
  end

  factory :api_key do
    user

    factory :expired_api_key do
      expires_at Time.zone.now - 100
    end

    factory :renewable_api_key do
      expires_at Time.zone.now + 8.days
    end
  end
end
