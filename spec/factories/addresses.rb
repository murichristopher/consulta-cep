FactoryBot.define do
  factory :address do
    sequence(:cep) { |n| "08190#{n.to_s.rjust(3, '0')}" } # Generates unique CEPs like 08140001, 08140002
    street { "Rua Siqueira Rendon" }
    district { "Jardim Matagal" }
    city { "São Paulo" }
    state { "SP" }
    ddd { "11" }
    search_count { 0 }
  end
end
