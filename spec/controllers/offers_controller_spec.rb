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
end
