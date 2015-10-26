require 'rails_helper'

RSpec.describe Checkout do
  describe '.perform' do
    subject { described_class.perform(cart, attributes) }
    let!(:offer) { Offer.make! }
    let!(:user) { User.make! }

    context 'Invalid payment method' do
      let!(:cart) do
        CartSession.new(ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 } ]))
      end
      let!(:attributes) { ActionController::Parameters.new() }

      it 'returns checkout_path with flash alert to try again' do
        expected = [Rails.application.routes.url_helpers.checkout_path, flash: { alert: 'Tente novamente' }]
        is_expected.to eq(expected)
      end
    end

    context 'Valid payment method' do
      let!(:cart) do
        CartSession.new(ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 } ]))
      end

      context 'Bank slip' do
        let!(:attributes) { ActionController::Parameters.new(method: 'bank_slip', user: user) }

        before { expect_any_instance_of(Payment::BankSlip).to receive(:perform).once }
        before { expect_any_instance_of(Payment::BankSlip).to receive(:redirect_path).once }

        it 'calls Payment::BankSlip' do
          described_class.perform(cart, attributes)
        end
      end

      context 'Credit Card' do
        let!(:attributes) { ActionController::Parameters.new(method: 'credit_card', user: user) }

        before { expect_any_instance_of(Payment::CreditCard).to receive(:perform).once }
        before { expect_any_instance_of(Payment::CreditCard).to receive(:redirect_path).once }

        it 'calls Payment::CreditCard' do
          described_class.perform(cart, attributes)
        end
      end

      context 'Transfer' do
        let!(:attributes) { ActionController::Parameters.new(method: 'transfer', user: user) }

        before { expect_any_instance_of(Payment::Transfer).to receive(:perform) }
        before { expect_any_instance_of(Payment::Transfer).to receive(:redirect_path) }

        it 'calls Payment::Transfer' do
          described_class.perform(cart, attributes)
        end
      end
    end
  end
end
