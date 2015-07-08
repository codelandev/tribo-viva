require 'rails_helper'

RSpec.describe OldPurchasesController, type: :controller do

  describe "GET #show" do
    context 'Existing purchase' do
      let(:purchase) { OldPurchase.make!(:pending) }

      it "returns http success" do
        get :show, id: purchase.to_param
        expect(response).to have_http_status(:success)
      end
    end

    context '404' do
      it 'returns 404' do
        get :show, id: 'not-found'
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH #update" do
    let(:purchase) { OldPurchase.make!(:pending) }

    it "returns to old_purchase_path if valid file with notice flash" do
      file = fixture_file_upload('example.jpg', 'text/jpg')
      patch :update, id: purchase.transaction_id, purchase: { receipt: file }
      purchase.reload # need to reload the class to get changes
      expect(purchase.receipt.file.file).to be_present
      expect(purchase.status).to eql PurchaseStatus::CONFIRMED
      expect(response).to redirect_to success_old_purchase_path(purchase)
    end

    it "returns to old_purchase_path if empty file with alert flash" do
      patch :update, id: purchase.transaction_id, purchase: { receipt: '' }
      expect(purchase.receipt).to_not be_present
      expect(response).to redirect_to old_purchase_path(purchase)
      expect(flash[:alert]).to be_present
    end
  end

  describe "GET #success" do
    let(:pending_purchase) { OldPurchase.make!(:pending) }
    let(:confirmed_purchase) { OldPurchase.make!(:confirmed) }

    it "returns http success" do
      get :success, id: confirmed_purchase.transaction_id
      expect(response).to have_http_status(:success)
    end

    it "returns http redirect if not confirmed" do
      get :success, id: pending_purchase.transaction_id
      expect(response).to have_http_status(:redirect)
    end
  end
end
