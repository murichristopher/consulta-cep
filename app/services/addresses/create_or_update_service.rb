module Addresses
  class CreateOrUpdateService
    def initialize(address_data)
      @address_data = address_data
    end

    def call
      Rails.logger.info("[Addresses::CreateOrUpdateService] Starting process for CEP: #{@address_data[:cep]}")

      address = Address.find_or_create_by(cep: @address_data[:cep]) do |addr|
        Rails.logger.debug("[Addresses::CreateOrUpdateService] Assigning attributes: #{@address_data}")
        addr.assign_attributes(@address_data)
      end

      address.increment_count

      Rails.logger.info("[Addresses::CreateOrUpdateService] Address saved with ID: #{address.id}, Search Count: #{address.search_count}") if address.persisted?

      address
    rescue StandardError => e
      Rails.logger.error("[Addresses::CreateOrUpdateService] Error while saving address: #{e.message}")
      raise e
    end
  end
end
