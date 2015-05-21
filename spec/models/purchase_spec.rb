require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :offer }
    it { should validate_presence_of :status }
    it { should validate_presence_of :amount }
    it { should validate_presence_of(:receipt).on(:update) }
    it { should validate_numericality_of(:amount).is_greater_than(0).is_less_than(4).only_integer }
  end

  describe "relations" do
    it { should belong_to :user }
    it { should belong_to :offer }
  end

  describe "callbacks" do
    describe "before_save" do
      it "#generate_transaction_id" do
        purchase = Purchase.make!(:pending)
        expect(purchase.transaction_id).to be_present
      end
    end
  end

  describe "scopes" do
    let(:pending) { Purchase.make!(:pending) }
    let(:canceled) { Purchase.make!(:canceled) }
    let(:confirmed) { Purchase.make!(:confirmed) }

    context "#pending" do
      it { Purchase.pending.should == [pending] }
    end

    context "#canceled" do
      it { Purchase.canceled.should == [canceled] }
    end

    context "#confirmed" do
      it { Purchase.confirmed.should == [confirmed] }
    end
  end

  describe "methods" do
    describe "#confirm!" do
      it "must update status to confirmed" do
        @purchase = Purchase.make!(:pending)
        @purchase.confirm!
        expect(@purchase.status).to eql('confirmed')
      end
    end

    describe "#cancel!" do
      it "must update status to canceled" do
        @purchase = Purchase.make!(:pending)
        @purchase.cancel!
        expect(@purchase.status).to eql('canceled')
      end
    end
  end
end
