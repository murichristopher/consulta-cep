require 'rails_helper'

RSpec.describe Addresses::CreateOrUpdateService, type: :service do
  describe '#call' do
    let(:address_data) do
      {
        cep: '12345-678',
        street: 'Main St',
        city: 'Metropolis',
        state: 'NY'
      }
    end

    subject(:service_call) { described_class.new(address_data).call }

    context 'when the address does not exist' do
      it 'creates a new Address record' do
        expect { service_call }.to change(Address, :count).by(1)
      end

      it 'assigns the correct attributes' do
        address = service_call
        expect(address.cep).to eq('12345-678')
        expect(address.street).to eq('Main St')
        expect(address.city).to eq('Metropolis')
        expect(address.state).to eq('NY')
      end

      it 'increments the search_count' do
        address = service_call
        expect(address.search_count).to eq(1)
      end
    end

    context 'when the address already exists' do
      let!(:existing_address) do
        create(:address,
               cep: '12345-678',
               street: 'Old St',
               city: 'Old City',
               state: 'XX',
               search_count: 5)
      end

      it 'does not create a new record' do
        expect { service_call }.not_to change(Address, :count)
      end

      it 'increments the search_count on the existing address' do
        address = service_call
        expect(address.search_count).to eq(6)
      end
    end

    context 'when an error occurs' do
      before do
        allow(Address).to receive(:find_or_create_by)
          .and_raise(StandardError, 'Error')
      end

      it 'raises the error' do
        expect { service_call }.to raise_error(StandardError, 'Error')
      end
    end
  end
end