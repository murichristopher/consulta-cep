require 'rails_helper'

RSpec.describe "Ceps", type: :request do
  describe "GET /ceps" do
    let!(:address) do
      create(:address,
        cep: "08140490",
        city: "São Paulo",
        state: "SP",
        search_count: 5
      )
    end

    context "when the CEP exists in the database" do
      it "returns a successful response" do
        get ceps_path, params: { cep: "08140490" }
        expect(response).to have_http_status(:success)

        expect(response.body).to include("São Paulo")
        expect(response.body).to include("SP")
      end
    end

    context "when the CEP is not found" do
      before do
        allow(Cep::LookupService).to receive(:new).and_raise(Cep::LookupService::NotFoundError)
      end

      it "renders an error message" do
        get ceps_path, params: { cep: "00000000" }
        expect(response.body).to include(I18n.t("errors.cep_not_found"))
      end
    end

    context "when the CEP request fails" do
      before do
        allow(Cep::LookupService).to receive(:new).and_raise(Cep::LookupService::RequestError)
      end

      it "renders a request error message" do
        get ceps_path, params: { cep: "99999999" }
        expect(response.body).to include(I18n.t("errors.cep_request_error"))
      end
    end

    context "when the CEP lookup fails" do
      before do
        allow(Cep::LookupService).to receive(:new).and_raise(Cep::LookupService::LookupError)
      end

      it "renders a lookup error message" do
        get ceps_path, params: { cep: "88888888" }
        expect(response.body).to include(I18n.t("errors.cep_lookup_error"))
      end
    end

    context "when no CEP is provided" do
      it "returns a successful response with general statistics" do
        get ceps_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("Most Searched CEPs")
      end
    end

    context "when the CEP is not in the database but the service returns a valid address" do
      let(:mock_address) do
        { cep: "12345678", city: "Rio de Janeiro", state: "RJ", street: "Av. Atlântica" }
      end

      before do
        service_double = instance_double(Cep::LookupService, call: mock_address)
        allow(Cep::LookupService).to receive(:new).and_return(service_double)
      end

      it "creates a new record and shows the address details" do
        expect {
          get ceps_path, params: { cep: "12345678" }
        }.to change { Address.count }.by(1)

        expect(response).to have_http_status(:success)
        expect(response.body).to include("Rio de Janeiro")
        expect(response.body).to include("RJ")

        new_address = Address.find_by(cep: "12345678")
        expect(new_address).not_to be_nil
        expect(new_address.city).to eq("Rio de Janeiro")
        expect(new_address.search_count).to eq(1)
      end
    end

    context "when searching the same CEP multiple times" do
      let!(:cep_to_test) do
        create(:address, cep: "99999990", city: "Foobar", state: "FB", search_count: 5)
      end

      it "increments the search_count on each request" do
        expect {
          get ceps_path, params: { cep: "99999990" }
        }.to change { cep_to_test.reload.search_count }.by(1)

        expect {
          get ceps_path, params: { cep: "99999990" }
        }.to change { cep_to_test.reload.search_count }.by(1)
      end
    end
  end
end
