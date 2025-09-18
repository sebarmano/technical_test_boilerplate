FactoryBot.define do
  factory :job do
    title { Faker::Job.title }
    location { Faker::Address.city }
    employment_type { %w[full-time part-time contract freelance].sample }
    published_at { Faker::Time.between(from: 1.month.ago, to: Time.current) }
    company
  end
end
