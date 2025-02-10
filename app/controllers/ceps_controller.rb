class CepsController < ApplicationController
  rescue_from Cep::LookupService::NotFoundError, with: :handle_cep_not_found
  rescue_from Cep::LookupService::RequestError, with: :handle_cep_request_error
  rescue_from Cep::LookupService::LookupError,  with: :handle_cep_lookup_error

  def index
    if params[:cep].present?
      normalized_cep = params[:cep].gsub(/\D/, "")
      address_data = fetch_address_data(normalized_cep)
      @address = Addresses::CreateOrUpdateService.new(address_data).call
    end

    @most_searched_ceps         = Address.most_searched_ceps
    @ceps_by_state              = Address.ceps_by_state
    @most_searched_by_location  = Address.most_searched_by_location

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def fetch_address_data(cep)
    Address.find_by(cep: cep) || Cep::LookupService.new(cep).call
  end

  def handle_cep_not_found(exception)
    @error = I18n.t("errors.cep_not_found")
    render_index_with_error
  end

  def handle_cep_request_error(exception)
    @error = I18n.t("errors.cep_request_error")
    render_index_with_error
  end

  def handle_cep_lookup_error(exception)
    @error = I18n.t("errors.cep_lookup_error")
    render_index_with_error
  end

  def render_index_with_error
    respond_to do |format|
      format.html { render :index }
      format.turbo_stream { render :index }
    end
  end
end
