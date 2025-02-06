require 'faker'

puts 'Clearing old data...'
Address.destroy_all

puts 'Generating addresses...'
10.times do
  Address.create!(
    cep: Faker::Base.numerify('########'),
    street: Faker::Address.street_name,
    district: Faker::Address.community,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    ddd: Faker::Base.numerify('##'),
    search_count: rand(1..50)
  )
end

puts "Created #{Address.count} addresses."
