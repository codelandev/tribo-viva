require 'rails_helper'

RSpec.describe Payment::NotificationHandler do
  subject { described_class.new(attributes) }

  describe 'initializer' do
    let!(:attributes) { ActionController::Parameters.new(data: {}, event: 'xxx') }

    it 'sets #user' do
      expect(subject.data).to eq(attributes[:data])
    end

    it 'sets #event' do
      expect(subject.event).to eq(attributes[:event])
    end

    it 'not sets unknow attributes' do
      expect{ subject.bla }.to raise_error(NoMethodError)
    end
  end

  TEST_CASES = [
    {
      describe_text: 'existing invoice changing status to paid',
      status: :ok,
      event: 'invoice.status_changed',
      data: {
        id: '123abc',
        status: 'paid'
      }
    },
    {
      describe_text: 'existing invoice changing status to expired',
      status: :ok,
      event: 'invoice.status_changed',
      data: {
        id: '123abc',
        status: 'expired'
      }
    },
    {
      describe_text: 'not found invoice changing status',
      status: :not_found,
      event: 'invoice.status_changed',
      data: {
        id: 'not_found',
        status: 'paid'
      }
    },
    {
      describe_text: 'existing invoice refund',
      status: :not_found,
      event: 'invoice.status_changed',
      data: {
        id: '123abc',
        status: 'refund'
      }
    },
    {
      describe_text: 'existing invoice payment failed',
      status: :not_found,
      event: 'invoice.payment_failed',
      data: {
        id: '123abc',
        status: 'pending'
      }
    },
  ]

  TEST_CASES.each do |test_case|
    let!(:attributes) { ActionController::Parameters.new(text_case.slice(:data, :event)) }

    context "#{test_case[:describe_text]}" do
      before do
        if test_case[:status] == :ok
          is_expected.to receive(:purchase).and_return(Purchase.make).at_least(2).times
        end
      end

      describe '#perform' do
        it { expect(subject.perform).to be test_case[:status] == :ok }
      end

      describe '#render_status' do
        before { subject.perform }

        it { expect(subject.render_status).to eq(test_case[:status]) }
      end
    end
  end
end
