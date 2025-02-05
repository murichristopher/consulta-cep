class CepsController < ApplicationController
  def index
    if params[:cep].present?
      begin
        @address = Cep::LookupService.new(params[:cep]).call
      rescue Cep::LookupService::NotFoundError
        @error = I18n.t("errors.cep_not_found")
      rescue Cep::LookupService::RequestError
        @error = I18n.t("errors.cep_request_error")
      rescue Cep::LookupService::LookupError
        @error = I18n.t("errors.cep_lookup_error")
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end