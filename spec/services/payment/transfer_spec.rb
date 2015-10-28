require 'rails_helper'

RSpec.describe Payment::Transfer do
  let!(:cart) do
    CartSession.new(ActionController::TestSession.new(shopping_cart: []))
  end
  let!(:attributes) { ActionController::Parameters.new(user: user) }
  let!(:user) { User.make! }
  let!(:offer) { Offer.make! }

  subject { described_class.new(cart, attributes) }

  describe '#payment_method' do
    it { expect(subject.send(:payment_method)).to eq('transfer') }
  end

  describe '#taxes' do
    it { expect(subject.send(:taxes)).to eq(0.00) }
  end

  describe '#perform' do
    after { subject.perform }

    it { expect{ subject.perform }.not_to raise_error }

    it 'calls purchase' do
      is_expected.to receive(:purchase).once
    end

    it 'calls orders' do
      is_expected.to receive(:orders).once
    end

    it 'calls finish_purchase' do
      is_expected.to receive(:finish_purchase).once
    end
  end

  describe '#send_mail' do
    it 'sends an email' do
      expect(subject.purchase).to receive(:invoice_id).exactly(3).times.and_return('my-invoice')

      expect{ subject.send(:send_mail) }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end

  describe '#save_purchase' do
    it 'sets purchase#invoice_id' do
      expected = SecureRandom.hex(32)
      expect(SecureRandom).to receive(:hex).with(32).and_return(expected)
      expect(subject.purchase).to receive(:invoice_id=).with(expected)
      expect(subject.purchase).to receive(:save)
      subject.send(:save_purchase)
    end
  end

  describe '#redirect_path' do
    let!(:invoice_id) { 'some-invoice-id' }

    before { expect(subject.purchase).to receive(:invoice_id).and_return(invoice_id) }

    it 'returns an array with route and flash messages' do
      expected = [
        Rails.application.routes.url_helpers.checkout_transfer_path(invoice_id),
        flash: {
          notice: 'Aguardando confirmação'
        }
      ]
      expect(subject.redirect_path).to eq(expected)
    end
  end
end
