require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  describe 'GET #checkout' do
    let!(:user) { User.make! }
    let!(:offer) { Offer.make! }

    context 'Guest user' do
      before { get :checkout }

      it { expect(response).to have_http_status(:found) }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context 'Signed user' do
      context 'empty cart' do
        before do
          login_user(user)
          get :checkout
        end

        it { expect(response).to have_http_status(:found) }
        it { expect(response).to redirect_to(cart_path) }

        context 'flash message' do
          it { expect(flash[:alert]).to eq('Para realizar pagamento você deve ter items no carrinho')}
        end
      end

      context 'cart with items' do
        let!(:cart_session) do
          ActionController::TestSession.new(shopping_cart: [ { 'id' => offer.id, 'quantity' => 2 } ])
        end

        before do
          login_user(user)
          expect_any_instance_of(ApplicationController).to receive(:cart_session).at_least(1).and_return(CartSession.new(cart_session))
          get :checkout
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(response).to render_template(:checkout) }
      end
    end
  end
end
