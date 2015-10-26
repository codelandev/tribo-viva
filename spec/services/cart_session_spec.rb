require 'rails_helper'

RSpec.describe CartSession do
  let!(:offer) { Offer.make! }
  let(:session) { ActionController::TestSession.new }
  subject { described_class.new(session) }

  describe 'Included concerns' do
    [
      CartAdd,
      CartClean,
      CartList,
      CartRemove,
    ].each do |mod|

      it { is_expected.to be_an(mod) }
    end
  end

  describe 'Initialize' do
    context 'new cart' do
      it { expect(subject.session).to have_key(:shopping_cart) }
      it { expect(subject.session[:shopping_cart]).to eq([]) }
      it { expect(subject.cart).to eq([]) }
      it { expect(subject.cart).to eq(subject.session[:shopping_cart]) }

      it 'creates session[:shopping_cart] in session when load instance' do
        expect {
          subject
        }.to change{ session[:shopping_cart] }.from(nil).to([])
      end
    end

    context 'existing cart' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 } ])
      end

      it { expect(subject.session).to have_key(:shopping_cart) }
      it { expect(subject.cart).to eq(subject.session[:shopping_cart]) }
      it 'creates session[:shopping_cart] in session when load instance' do
        expect {
          subject
        }.not_to change{ session[:shopping_cart] }
      end
    end
  end

  describe '#add' do
    before { subject }

    context 'new item in cart' do
      context 'quantity <= 3' do
        context 'quantity == 0' do
          it { expect{ subject.add(offer, 0) }.to change{ session[:shopping_cart] }.from([]).to([{"id" => offer.id, "quantity" => 1}]) }
        end

        context 'quantity < 0' do
          it { expect{ subject.add(offer, -1) }.to change{ session[:shopping_cart] }.from([]).to([{"id" => offer.id, "quantity" => 1}]) }
        end

        context 'quantity == 1' do
          it { expect{ subject.add(offer, 1) }.to change{ session[:shopping_cart] }.from([]).to([{"id" => offer.id, "quantity" => 1}]) }
        end

        context 'quantity == nil' do
          it { expect{ subject.add(offer, nil) }.to change{ session[:shopping_cart] }.from([]).to([{"id" => offer.id, "quantity" => 1}]) }
        end

        context 'quantity == 2' do
          it { expect{ subject.add(offer, 2) }.to change{ session[:shopping_cart] }.from([]).to([{"id" => offer.id, "quantity" => 2}]) }
        end

        context 'quantity == 3' do
          it { expect{ subject.add(offer, 3) }.to change{ session[:shopping_cart] }.from([]).to([{"id" => offer.id, "quantity" => 3}]) }
        end
      end

      context 'quantity > 3' do
        it { expect{ subject.add(offer, 4) }.not_to change{ session[:shopping_cart] } }
        it { expect{ subject.add(offer, 4) }.to change{ subject.errors.length }.from(0).to(1) }
        it { expect{ subject.add(offer, 4) }.to change{ subject.errors }.from([]).to(['Você pode comprar no máximo 3 cotas de cada oferta']) }
      end
    end

    context 'existing item in cart' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 } ])
      end

      context 'quantity <= 3' do
        context 'quantity == 0' do
          it 'adds item' do
            subject.add(offer, 0)
            expect(session[:shopping_cart]).to eq([{"id" => offer.id, "quantity" => 2}])
          end
        end

        context 'quantity < 0' do
          it 'adds item' do
            subject.add(offer, -1)
            expect(session[:shopping_cart]).to eq([{"id" => offer.id, "quantity" => 2}])
          end
        end

        context 'quantity == 1' do
          it 'adds item' do
            subject.add(offer, 1)
            expect(session[:shopping_cart]).to eq([{"id" => offer.id, "quantity" => 2}])
          end
        end

        context 'quantity == nil' do
          it 'adds item' do
            subject.add(offer, nil)
            expect(session[:shopping_cart]).to eq([{"id" => offer.id, "quantity" => 2}])
          end
        end

        context 'quantity == 2' do
          it 'adds item' do
            subject.add(offer, 2)
            expect(session[:shopping_cart]).to eq([{"id" => offer.id, "quantity" => 3}])
          end
        end

        context 'quantity == 3' do
          it { expect{ subject.add(offer, 3) }.not_to change{ session[:shopping_cart] } }
          it { expect{ subject.add(offer, 3) }.to change{ subject.errors.length }.from(0).to(1) }
          it { expect{ subject.add(offer, 3) }.to change{ subject.errors }.from([]).to(['Você pode comprar no máximo 3 cotas de cada oferta']) }
        end
      end

      context 'quantity > 3' do
        it { expect{ subject.add(offer, 4) }.not_to change{ session[:shopping_cart] } }
        it { expect{ subject.add(offer, 4) }.to change{ subject.errors.length }.from(0).to(1) }
        it { expect{ subject.add(offer, 4) }.to change{ subject.errors }.from([]).to(['Você pode comprar no máximo 3 cotas de cada oferta']) }
      end
    end
  end

  describe '#remove' do
    let(:session) do
      ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 3 } ])
    end

    context 'existing item in cart' do
      before { subject }

      context '0 quantity' do
        let(:quantity) { 0 }

        it 'keeps session[:shopping_cart]' do
          expect {
            subject.remove(offer, quantity)
          }.not_to change{ session[:shopping_cart] }
        end
      end

      context '1 quantity' do
        let(:quantity) { 1 }

        it 'keeps session[:shopping_cart]' do
          subject.remove(offer, quantity)
          expect(session[:shopping_cart]).to eq([{ 'id' => offer.id, 'quantity' => 2 }])
        end
      end

      context 'nil quantity' do
        let(:quantity) { nil }

        it 'keeps session[:shopping_cart]' do
          subject.remove(offer, quantity)
          expect(session[:shopping_cart]).to eq([{ 'id' => offer.id, 'quantity' => 2 }])
        end
      end

      context 'in the middle quantity' do
        let(:quantity) { 2 }

        it 'keeps session[:shopping_cart]' do
          subject.remove(offer, quantity)
          expect(session[:shopping_cart]).to eq([{ 'id' => offer.id, 'quantity' => 1 }])
        end
      end

      context 'all quantity' do
        let(:quantity) { 3 }

        it 'keeps session[:shopping_cart]' do
          expect {
            subject.remove(offer, quantity)
          }.to change{ session[:shopping_cart] }.from([{ 'id' => offer.id, 'quantity' => 3 }]).to([])
        end
      end

      context 'more quantity than have' do
        let(:quantity) { 4 }

        it 'keeps session[:shopping_cart]' do
          expect {
            subject.remove(offer, quantity)
          }.to change{ session[:shopping_cart] }.from([{ 'id' => offer.id, 'quantity' => 3 }]).to([])
        end
      end
    end

    context 'without item in cart' do
      after do
        it 'keeps session[:shopping_cart]' do
          expect {
            subject.remove(offer, quantity)
          }.not_to change{ session[:shopping_cart] }
        end
      end

      context '0 quantity' do
        let(:quantity) { 0 }
      end

      context '1 quantity' do
        let(:quantity) { 1 }
      end

      context 'nil quantity' do
        let(:quantity) { nil }
      end

      context 'in the middle quantity' do
        let(:quantity) { 2 }
      end

      context 'all quantity' do
        let(:quantity) { 3 }
      end

      context 'more quantity than have' do
        let(:quantity) { 4 }
      end
    end
  end

  describe '#clean' do
    context 'existing items' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 2 } ])
      end

      it 'cleans session[:shopping_cart]' do
        expect {
          subject.clean
        }.to change{ session[:shopping_cart] }.from([ { 'id' => offer.id, 'quantity' => 2 } ]).to([])
      end
    end

    context 'already empty cart' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [])
      end

      it 'cleans session[:shopping_cart]' do
        expect {
          subject.clean
        }.not_to change{ session[:shopping_cart] }
      end
    end
  end

  describe '#items_count' do

    context 'empty cart' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [])
      end
    end

    context 'cart with items' do
      context 'quantity == 1' do
        context 'with one item' do
          let(:session) do
            ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 } ])
          end

          it { expect(subject.items_count).to eq(1) }
        end

        context 'with multiple items' do
          let(:session) do
            ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 1 }, { 'id' => offer.id + 1, 'quantity' => 1 } ])
          end

          it { expect(subject.items_count).to eq(2) }
        end
      end

      context 'quantity > 1' do
        context 'with one item' do
          let(:session) do
            ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 2 } ])
          end

          it { expect(subject.items_count).to eq(1) }
        end

        context 'with multiple items' do
          let(:session) do
            ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 3 }, { 'id' => offer.id + 1, 'quantity' => 2 } ])
          end

          it { expect(subject.items_count).to eq(2) }
        end
      end
    end
  end

  describe '#cart_list' do
    describe CartList::CartListItem do
      it { is_expected.to respond_to(:offer) }
      it { is_expected.to respond_to(:total_price) }
      it { is_expected.to respond_to(:piece_price) }
      it { is_expected.to respond_to(:quantity) }
    end

    context 'empty cart' do
      it { expect(subject.cart_list).to be_empty }
      it { expect(subject.cart_list).to be_a(Array) }
    end

    context 'cart with items' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 2 } ])
      end

      it 'returns an array of CartList::CartListItem' do
        subject.cart_list.each do |item|
          expect(item).to be_a(CartList::CartListItem)
        end
      end

      it 'size == cart.length' do
        expect(subject.cart_list.size).to eq(1)
      end

      it 'element.offer == offer' do
        expect(subject.cart_list.first.offer).to eq(offer)
      end

      it 'element.total_price == offer.value + offer.coordinator_tax + offer.operational_tax * element.quantity' do
        expected = offer.value + offer.coordinator_tax + offer.operational_tax
        expected *= 2
        expect(subject.cart_list.first.total_price).to eq(expected)
      end

      it 'element.piece_price not includes quantity' do
        expected = offer.value + offer.coordinator_tax + offer.operational_tax
        expect(subject.cart_list.first.piece_price).to eq(expected)
      end

      it 'element.quantity == quantity' do
        expect(subject.cart_list.first.quantity).to eq(2)
      end
    end
  end

  describe '#total_value' do
    context 'empty cart' do
      it { expect(subject.total_value).to be_zero }
    end

    context 'cart with items' do
      let(:session) do
        ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 2 } ])
      end

      it 'returns sum of quantity * (value+coordinator_tax+operational_tax) + card_fees' do
        expected = offer.value + offer.coordinator_tax + offer.operational_tax
        expected *= 2
        expected = ((expected * 0.04715) + 0.30).round(2) + expected
        expect(subject.total_value).to eq(expected)
      end
    end
  end
end
