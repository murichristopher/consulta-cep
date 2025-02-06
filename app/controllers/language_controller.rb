class LanguageController < ApplicationController
  def change
    if params[:lang].present?
      lang_sym = params[:lang].to_sym
      I18n.locale = lang_sym if I18n.available_locales.include?(lang_sym)
    end

    session[:locale] = I18n.locale.to_s

    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end
