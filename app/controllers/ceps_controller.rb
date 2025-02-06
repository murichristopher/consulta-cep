class CepsController < ApplicationController
  def index
    if params[:cep].present?
      normalized_cep = params[:cep].gsub(/\D/, "")

      begin
        address_data = address_data(normalized_cep)
        @address = Addresses::CreateOrUpdateService.new(address_data).call
      rescue Cep::LookupService::NotFoundError
        @error = I18n.t("errors.cep_not_found")
      rescue Cep::LookupService::RequestError
        @error = I18n.t("errors.cep_request_error")
      rescue Cep::LookupService::LookupError
        @error = I18n.t("errors.cep_lookup_error")
      end
    end

    @most_searched_ceps = Address.most_searched_ceps
    @ceps_by_state = Address.ceps_by_state
    @most_searched_by_location = Address.most_searched_by_location

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def address_data(cep)
    Address.find_by(cep: cep) || Cep::LookupService.new(cep).call
  end
end
