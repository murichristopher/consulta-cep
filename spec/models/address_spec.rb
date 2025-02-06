require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "validations" do
    subject { create(:address) }

    it { should validate_presence_of(:cep) }
    it { should validate_uniqueness_of(:cep).case_insensitive }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
  end

  describe "scopes" do
    let!(:address1) { create(:address, cep: "12345678", search_count: 10, state: "SP", city: "São Paulo") }
    let!(:address2) { create(:address, cep: "87654321", search_count: 20, state: "RJ", city: "Rio de Janeiro") }
    let!(:address3) { create(:address, cep: "11223344", search_count: 5, state: "SP", city: "Campinas") }
    let!(:address4) { create(:address, cep: "55667788", search_count: 15, state: "MG", city: "Belo Horizonte") }

    describe ".most_searched_ceps" do
      it "returns the most searched CEPs ordered by search_count" do
        expect(Address.most_searched_ceps(3)).to eq({
          "87654321" => 20,
          "55667788" => 15,
          "12345678" => 10
        })
      end
    end

    describe ".ceps_by_state" do
      it "returns the count of addresses per state ordered by highest count" do
        expect(Address.ceps_by_state).to eq({
          "SP" => 2,
          "RJ" => 1,
          "MG" => 1
        })
      end
    end

    describe ".most_searched_by_location" do
      it "returns the most searched locations" do
        expect(Address.most_searched_by_location(3)).to eq({
          [ "Rio de Janeiro", "RJ" ] => 20,
          [ "Belo Horizonte", "MG" ] => 15,
          [ "São Paulo", "SP" ] => 10
        })
      end
    end
  end

  describe "#formatted_cep" do
    it "formats the CEP correctly" do
      address = build(:address, cep: "12345678")
      expect(address.formatted_cep).to eq("12345-678")
    end
  end

  describe "#increment_count" do
    it "increments the search_count" do
      address = create(:address, search_count: 5)
      expect { address.increment_count }.to change { address.reload.search_count }.by(1)
    end
  end
end
