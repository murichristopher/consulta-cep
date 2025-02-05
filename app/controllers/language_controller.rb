class LanguageController < ApplicationController
  def change
    I18n.locale = params[:lang] if I18n.available_locales.include?(params[:lang].to_sym)
    session[:locale] = I18n.locale
    respond_to do |format|
      format.json { render json: { success: true } }
    end
  end
end