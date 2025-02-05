# app/services/cep/lookup_service.rb
module Cep
  class LookupService
    class LookupError < StandardError; end
    class NotFoundError < StandardError; end
    class RequestError < StandardError; end

    API_BASE_URL = ENV.fetch("CEP_API_URL", "https://cep.awesomeapi.com.br")
    DEFAULT_FORMAT = "json"

    def initialize(cep)
      @cep = normalize_cep(cep)
    end

    def call
      Rails.logger.info("[Cep::LookupService] Starting lookup for CEP: #{@cep}")
      Rails.logger.debug("[Cep::LookupService] Constructed URL: #{url}")

      response = Faraday.get(url)
      Rails.logger.info("[Cep::LookupService] Received response with status: #{response.status}")

      unless response.success?
        case response.status
        when 400
          error_data = JSON.parse(response.body) rescue {}
          error_message = error_data["message"]
          Rails.logger.error("[Cep::LookupService] Invalid CEP: #{error_message}")
          raise RequestError, error_message
        when 404
          error_data = JSON.parse(response.body) rescue {}
          error_message = error_data["message"]
          Rails.logger.error("[Cep::LookupService] CEP not found: #{error_message}")
          raise NotFoundError, error_message
        else
          Rails.logger.error("[Cep::LookupService] Request error with status: #{response.status}")
          raise RequestError
        end
      end

      data = JSON.parse(response.body)
      Rails.logger.debug("[Cep::LookupService] Response data: #{data}")

      formatted_data = format_data(data)
      Rails.logger.info("[Cep::LookupService] Formatted data: #{formatted_data}")

      formatted_data
    rescue Faraday::Error, JSON::ParserError => e
      Rails.logger.error("[Cep::LookupService] Error during lookup: #{e.message}")
      raise LookupError, e.message
    end

    private

    def url
      "#{API_BASE_URL}/#{DEFAULT_FORMAT}/#{@cep}"
    end

    def normalize_cep(cep)
      cep.gsub(/\D/, "")
    end

    def format_data(data)
      {
        cep:       data["cep"],
        street:    data["address"],
        district:  data["district"],
        city:      data["city"],
        state:     data["state"],
        ddd:       data["ddd"]
      }
    end
  end
end
