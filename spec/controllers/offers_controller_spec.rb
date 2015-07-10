require 'rails_helper'

RSpec.describe OffersController, type: :controller do
  describe "GET #home" do
    let(:valid_offer) { Offer.make! }

    it "returns http success when valid ID" do
      get :show, id: valid_offer.id
      expect(response).to have_http_status(:success)
    end

    it "returns http error when invalid ID" do
      get :show, id: '0'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #new_purchase" do
    let(:valid_offer) { Offer.make! }

    it "returns http success when valid ID" do
      get :new_purchase, id: valid_offer.id
      expect(response).to have_http_status(:success)
    end

    it "returns http error when invalid ID" do
      get :new_purchase, id: '0'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #purchase" do
    let(:user) { User.make! }
    let(:offer) { Offer.make! }
    let(:invalid_offer) { Offer.make!(stock: 0) }

    before do
      @valid_registered_user     = { amount: '1', user_status: 'true', email: user.email }
      @invalid_registered_user   = { amount: '4', user_status: 'true', email: user.email }
      @valid_unregistered_user   = { amount: '1', user_status: 'false', name: 'User Test', email: 'test@test.com', cpf: '00000000000', phone: '(51) 3779-9710', address: 'Felipe neri' }
      @invalid_unregistered_user = { amount: '4', user_status: 'false', name: 'User Test', email: 'test@test.com', cpf: '00000000000', phone: '(51) 3779-9710' }
    end

    context 'when stock is zero' do
      it "return error even with valid parameters" do
        post :create_purchase, id: invalid_offer.id, purchase_form: @valid_registered_user

        expect(OldPurchase.count).to eq(0)
        expect(response).to redirect_to new_purchase_offer_path(invalid_offer)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is registered' do
      it "returns success and redirect to root if valid parameters" do
        post :create_purchase, id: offer.id, purchase_form: @valid_registered_user

        expect(OldPurchase.count).to eq(1)
        expect(OldPurchase.last.amount).to eq(@valid_registered_user[:amount].to_i)
        expect(OldPurchase.last.status).to eq(OldPurchaseStatus::PENDING)
        expect(OldPurchase.last.offer.remaining).to eq(10)
        expect(ActionMailer::Base.deliveries.last.to.first).to eql @valid_registered_user[:email]
        expect(response).to redirect_to old_purchase_path(OldPurchase.last)
        expect(flash[:notice]).to be_present
      end

      it "returns error and render purchase if invalid parameters" do
        post :create_purchase, id: offer.id, purchase_form: @invalid_registered_user
        expect(response).to render_template :new_purchase
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is not registered' do
      it "returns success and redirect to root if valid parameters" do
        post :create_purchase, id: offer.to_param, purchase_form: @valid_unregistered_user

        expect(User.exists?(email: @valid_unregistered_user[:email])).to be_truthy
        expect(OldPurchase.count).to eq(1)
        expect(OldPurchase.last.amount).to eq(@valid_unregistered_user[:amount].to_i)
        expect(OldPurchase.last.status).to eq(OldPurchaseStatus::PENDING)
        expect(OldPurchase.last.offer.remaining).to eq(10)
        expect(ActionMailer::Base.deliveries.last.to.first).to eql @valid_unregistered_user[:email]
        expect(response).to redirect_to old_purchase_path(OldPurchase.last)
        expect(flash[:notice]).to be_present
      end

      it "returns error and render purchase if invalid parameters" do
        post :create_purchase, id: offer.id, purchase_form: @invalid_unregistered_user
        expect(response).to render_template :new_purchase
        expect(flash[:alert]).to be_present
      end
    end
  end
end
