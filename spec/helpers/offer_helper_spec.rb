require 'rails_helper'

describe OfferHelper, type: :helper do
  describe '#progress_bar_percentage' do
    let!(:offer) { Offer.new(stock: 100) }
    before { expect(offer).to receive(:remaining).and_return(remaining) }

    context 'Offer without purchases' do
      let!(:remaining) { offer.stock }

      it 'returns 0' do
        expect(helper.progress_bar_percentage(offer)).to be_zero
      end
    end

    context 'verify limits' do
      context 'min' do
        let!(:remaining) { -1 }

        it 'returns 0' do
          expect(helper.progress_bar_percentage(offer)).to eq(100)
        end
      end

      context 'max' do
        let!(:remaining) { offer.stock * 2 }

        it 'returns 100' do
          expect(helper.progress_bar_percentage(offer)).to be_zero
        end
      end
    end

    context 'Complete offer' do
      let!(:remaining) { 0 }

      it 'returns 100' do
        expect(helper.progress_bar_percentage(offer)).to eq(100)
      end
    end
  end
end
