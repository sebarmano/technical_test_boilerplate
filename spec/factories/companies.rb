FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    website { Faker::Internet.url }
  end
end
