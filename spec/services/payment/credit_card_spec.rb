require 'rails_helper'

RSpec.describe Payment::CreditCard do
  let!(:cart) do
    CartSession.new(ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 } ]))
  end
  let!(:attributes) { ActionController::Parameters.new(user: user, token: 'awsome-token') }
  let!(:user) { User.make! }
  let!(:offer) { Offer.make! }

  subject { described_class.new(cart, attributes) }

  describe '#payment_method' do
    it { expect(subject.send(:payment_method)).to eq('credit_card') }
  end

  describe '#taxes' do
    it { expect(subject.send(:taxes)).to eq(cart.total_card_fee) }
  end

  describe '#due_date' do
    it 'returns a hash with due_date of today' do
      expect(Date).to receive(:tomorrow).and_return(Date.new(2015, 10, 30))
      expected = { due_date: '30/10/2015' }
      expect(subject.send(:due_date)).to eq(expected)
    end
  end

  describe '#charge_param' do
    it 'returns a hash with token' do
      expect(subject.send(:charge_param)).to eq({ token: 'awsome-token' })
    end
  end
end
