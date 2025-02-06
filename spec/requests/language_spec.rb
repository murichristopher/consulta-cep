require 'rails_helper'

RSpec.describe "Language", type: :request do
  describe "POST /language/change" do
    before do
      I18n.available_locales = [ :en, :es, :fr, :pt ]
    end

    context "when a valid language is provided" do
      it "changes the locale and stores it in the session" do
        post change_language_path, params: { lang: "es" }, as: :json

        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include("success" => true)
        expect(session[:locale]).to eq("es")
        expect(I18n.locale).to eq(:es)
      end
    end

    context "when an invalid language is provided" do
      it "does not change the locale" do
        post change_language_path, params: { lang: "xx" }, as: :json

        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include("success" => true)
        expect(session[:locale]).not_to eq("xx")
        expect(I18n.locale).not_to eq(:xx)
      end
    end

    context "when no language is provided" do
      it "does not change the locale" do
        post change_language_path, params: {}, as: :json

        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to include("success" => true)
        expect(session[:locale]).not_to be_nil
      end
    end
  end
end
