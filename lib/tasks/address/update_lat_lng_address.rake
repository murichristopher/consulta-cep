namespace :address do
  desc 'Atualiza longitude e latitude de endereços'
  task update_lat_lng_address: :environment do
    Address.where(lat: nil, lng: nil).each do |address|
      cep = address.cep
      address_data = Cep::LookupService.new(cep).call

      address.update!(lat: address_data[:lat], lng: address_data[:lng])
    end
  end
end
