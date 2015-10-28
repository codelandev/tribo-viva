require 'rails_helper'

RSpec.describe OldPurchase, type: :model do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :status }
    it { should validate_presence_of :amount }
    it { should validate_presence_of(:receipt).on(:update) }
  end

  describe "relations" do
    it { should belong_to :user }
    it { should belong_to :offer }
  end

  describe "callbacks" do
    describe "before_validation" do
      it "#generate_transaction_id" do
        purchase = OldPurchase.make!(:pending)
        expect(purchase.transaction_id).to be_present
      end
    end
  end

  describe "scopes" do
    let(:pending) { OldPurchase.make!(:pending) }
    let(:canceled) { OldPurchase.make!(:canceled) }
    let(:confirmed) { OldPurchase.make!(:confirmed) }

    context "#pending" do
      it { expect(OldPurchase.pending).to eq [pending] }
    end

    context "#canceled" do
      it { expect(OldPurchase.canceled).to eq [canceled] }
    end

    context "#confirmed" do
      it { expect(OldPurchase.confirmed).to eq [confirmed] }
    end
  end

  describe "methods" do
    describe "#confirm!" do
      it "must update status to confirmed" do
        purchase = OldPurchase.make!(:pending)
        purchase.confirm!
        expect(purchase.status).to eql('confirmed')
      end
    end

    describe "#cancel!" do
      it "must update status to canceled" do
        purchase = OldPurchase.make!(:pending)
        purchase.cancel!
        expect(purchase.status).to eql('canceled')
      end
    end

    describe "#total" do
      it "must show the amount times offer value" do
        expect(OldPurchase.make!(:confirmed).total).to eql(99.8)
      end
    end
  end
end
