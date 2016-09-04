require 'rails_helper'

RSpec.describe Offer, type: :model do
  describe "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :image }
    it { should validate_presence_of :stock }
    it { should validate_presence_of :producer }
    it { should validate_presence_of :description }
    it { should validate_presence_of :bank_account }
    it { should validate_presence_of :offer_ends_at }
    it { should validate_presence_of :collect_ends_at }
    it { should validate_presence_of :offer_starts_at }
    it { should validate_presence_of :collect_starts_at }
    it { should validate_presence_of :deliver_coordinator }
  end

  describe "relations" do
    it { should have_many :orders }
    it { should belong_to :producer }
    it { should have_many :offer_items }
    it { should belong_to :bank_account }
    it { should belong_to :deliver_coordinator }
  end

  describe "scopes" do
    let(:valid) { Offer.make!(offer_ends_at: 1.day.from_now) }
    let(:invalid_date) { Offer.make!(offer_ends_at: 1.day.ago) }
    let(:invalid_stock) { Offer.make!(stock: 0) }

    context "#valid_offers" do
      it { expect(Offer.valid_offers).to eq [valid] }
      it { expect(Offer.valid_offers).not_to eq [invalid_stock, invalid_date] }
    end

    context "#finished_offers" do
      it { expect(Offer.finished_offers).to eq [invalid_stock, invalid_date] }
      it { expect(Offer.finished_offers).not_to eq [valid] }
    end
  end

  describe "methods" do
    describe "#remaining!" do
      it "show the remaining offers" do
        offer = Offer.make!
        stock_before = offer.stock

        3.times do
          Order.make!(offer: offer, purchase: Purchase.make!(status: PurchaseStatus::PAID))
          Order.make!(offer: offer, purchase: Purchase.make!(status: PurchaseStatus::PENDING))
          Order.make!(offer: offer, purchase: Purchase.make!(status: PurchaseStatus::CANCELED))
          Order.make!(offer: offer, purchase: Purchase.make!(status: PurchaseStatus::EXPIRED))
          Order.make!(offer: offer, purchase: Purchase.make!(status: PurchaseStatus::REFUNDED))
        end

        expect(offer.remaining).to eql(stock_before - 3 - 1) # -1 because of reserved purchase of deliver coordinator
      end
    end
  end

  describe 'create_coordinator_reserv' do
    it 'creates a new Purchase' do
      expect{ Offer.make! }.to change(Purchase, :count).by(1)
    end

    it 'creates a new Order' do
      expect{ Offer.make! }.to change(Order, :count).by(1)
    end

    it 'creates a new Purchase of coordinator' do
      offer = Offer.make!
      expect(Purchase.last.user).to eq(offer.deliver_coordinator)
    end

    it 'creates a new Purchase with R$0.00 total' do
      Offer.make!
      expect(Purchase.last.total).to be_zero
    end

    it 'creates a new Order with R$0.00 value' do
      Offer.make!
      expect(Order.last.offer_value).to be_zero
    end

    it 'creates a new Order with 1 quantity' do
      Offer.make!
      expect(Order.last.quantity).to eq(1)
    end

    it 'creates a new Order of purchase' do
      offer = Offer.make!
      expect(Order.last.purchase).to eq(Purchase.last)
      expect(Order.last.offer).to eq(offer)
    end
  end
end
