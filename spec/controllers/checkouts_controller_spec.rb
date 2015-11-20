require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  describe 'GET #transfer' do
    let!(:purchase) { Purchase.make!(status: PurchaseStatus::PENDING) }
    let!(:invalid_purchase) { Order.make!(:invalid).purchase }

    context 'Guest user' do
      before { get :transfer, invoice_id: purchase.invoice_id }

      it { expect(response).to redirect_to(new_user_session_path) }

      context 'flash message' do
        it { expect(flash).to be_present }
        it { expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated')) }
      end
    end

    context 'Signed user' do
      context 'Purchase user' do
        let!(:user) { purchase.user }

        context 'try to upload when purchase is pending' do
          before do
            login_user(user)
            get :transfer, invoice_id: purchase.invoice_id
          end

          it { expect(response).to have_http_status(:ok) }
          it { expect(response).to render_template(:transfer) }
        end

        context 'try to upload when purchase has invalid offers' do
          before do
            login_user(user)
            get :transfer, invoice_id: invalid_purchase.invoice_id
          end

          it { expect(response).to redirect_to(root_path) }

          context 'flash message' do
            it { expect(flash).to be_present }
            it { expect(flash[:alert]).to eq(I18n.t('checkouts.upload_denied')) }
          end
        end
      end

      context 'Other user' do
        let!(:user) { User.make! }

        context 'try to upload when purchase is pending' do
          before do
            login_user(user)
            get :transfer, invoice_id: purchase.invoice_id
          end

          it { expect(response).to redirect_to(root_path) }

          context 'flash message' do
            it { expect(flash).to be_present }
            it { expect(flash[:alert]).to eq(I18n.t('checkouts.upload_denied')) }
          end
        end

        context 'try to upload when purchase has invalid offers' do
          before do
            login_user(user)
            get :transfer, invoice_id: invalid_purchase.invoice_id
          end

          it { expect(response).to redirect_to(root_path) }

          context 'flash message' do
            it { expect(flash).to be_present }
            it { expect(flash[:alert]).to eq(I18n.t('checkouts.upload_denied')) }
          end
        end
      end
    end
  end

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
          it { expect(flash[:alert]).to eq(I18n.t('checkouts.must_have_items_in_cart'))}
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
