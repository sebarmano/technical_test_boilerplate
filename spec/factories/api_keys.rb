FactoryBot.define do
  factory :api_key do
    key { SecureRandom.hex(32) }
    client { Faker::Company.name }
    deactivated_at { nil }

    trait :deactivated do
      deactivated_at { 1.day.ago }
    end
  end
end
