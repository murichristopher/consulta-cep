require 'rails_helper'

RSpec.describe Cep::LookupService, type: :service do
  describe '#call' do
    let(:cep_input)    { '12.345-678' }
    let(:normalized_cep) { '12345678' }
    let(:service)      { described_class.new(cep_input) }

    let(:api_url) do
      "#{described_class::API_BASE_URL}/#{described_class::DEFAULT_FORMAT}/#{normalized_cep}"
    end

    context 'when the lookup is successful' do
      let(:api_response_body) do
        {
          "cep"     => "12345678",
          "address" => "Rua Falsa",
          "district"=> "Bairro Falso",
          "city"    => "Cidade Falsa",
          "state"   => "SP",
          "ddd"     => "11",
          "lat"     => "-23.550520",
          "lng"     => "-46.633308"
        }.to_json
      end

      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: api_response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns a formatted hash with the correct data' do
        result = service.call
        expect(result).to eq(
          cep:      "12345678",
          street:   "Rua Falsa",
          district: "Bairro Falso",
          city:     "Cidade Falsa",
          state:    "SP",
          ddd:      "11",
          lat: "-23.550520",
          lng: "-46.633308",
        )
      end
    end

    context 'when the request returns 400 (invalid CEP)' do
      let(:error_message) { 'Invalid CEP format' }
      let(:response_body) { { "message" => error_message }.to_json }

      before do
        stub_request(:get, api_url)
          .to_return(status: 400, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Cep::LookupService::RequestError with the error message' do
        expect { service.call }.to raise_error(Cep::LookupService::RequestError, error_message)
      end
    end

    context 'when the request returns 404 (CEP not found)' do
      let(:error_message) { 'CEP not found' }
      let(:response_body) { { "message" => error_message }.to_json }

      before do
        stub_request(:get, api_url)
          .to_return(status: 404, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'raises Cep::LookupService::NotFoundError with the error message' do
        expect { service.call }.to raise_error(Cep::LookupService::NotFoundError, error_message)
      end
    end

    context 'when the request returns another error status (e.g., 500)' do
      before do
        stub_request(:get, api_url)
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises Cep::LookupService::RequestError' do
        expect { service.call }.to raise_error(Cep::LookupService::RequestError)
      end
    end

    context 'when Faraday or JSON raises an error' do
      before do
        allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError.new('timeout'))
      end

      it 'raises Cep::LookupService::LookupError' do
        expect { service.call }.to raise_error(Cep::LookupService::LookupError, /timeout/)
      end
    end
  end
end
