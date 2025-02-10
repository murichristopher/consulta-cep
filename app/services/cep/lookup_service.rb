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
      process_response(response)
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

    def process_response(response)
      unless response.success?
        handle_error_response(response)
      end

      data = parse_response(response.body)
      Rails.logger.debug("[Cep::LookupService] Response data: #{data}")

      formatted_data = format_data(data)
      Rails.logger.info("[Cep::LookupService] Formatted data: #{formatted_data}")

      formatted_data
    end

    def parse_response(body)
      JSON.parse(body)
    end

    def handle_error_response(response)
      case response.status
      when 400
        handle_bad_request(response)
      when 404
        handle_not_found(response)
      else
        handle_generic_error(response)
      end
    end

    def safe_parse(body)
      JSON.parse(body) rescue {}
    end

    def handle_bad_request(response)
      error_data = safe_parse(response.body)
      error_message = error_data["message"]
      Rails.logger.error("[Cep::LookupService] Invalid CEP: #{error_message}")
      raise RequestError, error_message
    end

    def handle_not_found(response)
      error_data = safe_parse(response.body)
      error_message = error_data["message"]
      Rails.logger.error("[Cep::LookupService] CEP not found: #{error_message}")
      raise NotFoundError, error_message
    end

    def handle_generic_error(response)
      Rails.logger.error("[Cep::LookupService] Request error with status: #{response.status}")
      raise RequestError
    end

    def format_data(data)
      {
        cep:       data["cep"],
        street:    data["address"],
        district:  data["district"],
        city:      data["city"],
        state:     data["state"],
        ddd:       data["ddd"],
        lat:       data["lat"],
        lng:       data["lng"]
      }
    end
  end
end