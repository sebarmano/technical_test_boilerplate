require "faker"
require "open-uri"

Company.destroy_all
Job.destroy_all

10.times do
  company = Company.create(name: Faker::Company.name, website: Faker::Internet.url)
  begin
    logo_url = Faker::Avatar.image
    logo_io = URI.open(logo_url)
    company.logo.attach(io: logo_io, filename: "#{company.name.parameterize}.png")
    company.save
  rescue => e
    puts "Failed to attach logo for #{company.name}: #{e.message}"
  end
end

200.times do
  company = Company.order("RANDOM()").first
  job = Job.create(title: Faker::Job.title, company: company, location: Faker::Address.city, published_at: Faker::Date.between(from: 1.year.ago, to: Date.today))
  job.description.body = Faker::Lorem.paragraph
  job.save
end

puts "Seeded #{Company.count} companies and #{Job.count} jobs"
