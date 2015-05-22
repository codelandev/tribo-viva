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
      @valid_registered_user     = { amount: '1', status: 'true', registered_user_email: user.email }
      @invalid_registered_user   = { amount: '4', status: 'true', registered_user_email: user.email }
      @valid_unregistered_user   = { amount: '1', status: 'false', unregistered_user_name: 'User Test', unregistered_user_email: 'test@test.com', unregistered_user_cpf: '00000000000' }
      @invalid_unregistered_user = { amount: '4', status: 'false', unregistered_user_name: 'User Test', unregistered_user_email: 'test@test.com', unregistered_user_cpf: '00000000000' }
    end

    context 'when stock is zero' do
      it "return error even with valid parameters" do
        post :create_purchase, id: invalid_offer.id, purchase: @valid_registered_user

        expect(Purchase.count).to eq(0)
        expect(response).to redirect_to offer_path(invalid_offer)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is registered' do
      it "returns success and redirect to root if valid parameters" do
        post :create_purchase, id: offer.id, purchase: @valid_registered_user

        expect(Purchase.count).to eq(1)
        expect(Purchase.last.amount).to eq(@valid_registered_user[:amount].to_i)
        expect(Purchase.last.status).to eq(PurchaseStatus::PENDING)
        expect(Purchase.last.offer.remaining).to eq(9)
        expect(ActionMailer::Base.deliveries.last.to.first).to eql @valid_registered_user[:registered_user_email]
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to be_present
      end

      it "returns error and render purchase if invalid parameters" do
        post :create_purchase, id: offer.id, purchase: @invalid_registered_user
        expect(response).to render_template :new_purchase
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is not registered' do
      it "returns success and redirect to root if valid parameters" do
        post :create_purchase, id: offer.id, purchase: @valid_unregistered_user

        expect(User.where(email: @valid_unregistered_user[:unregistered_user_email]).any?).to be_truthy
        expect(Purchase.count).to eq(1)
        expect(Purchase.last.amount).to eq(@valid_unregistered_user[:amount].to_i)
        expect(Purchase.last.status).to eq(PurchaseStatus::PENDING)
        expect(Purchase.last.offer.remaining).to eq(9)
        expect(ActionMailer::Base.deliveries.last.to.first).to eql @valid_unregistered_user[:unregistered_user_email]
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to be_present
      end

      it "returns error and render purchase if invalid parameters" do
        post :create_purchase, id: offer.id, purchase: @invalid_unregistered_user
        expect(response).to render_template :new_purchase
        expect(flash[:alert]).to be_present
      end
    end
  end
end
