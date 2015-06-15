require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do

  describe "GET #show" do
    let(:purchase) { Purchase.make!(:pending) }

    it "returns http success" do
      get :show, id: purchase.transaction_id
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    let(:purchase) { Purchase.make!(:pending) }

    it "returns to purchase_path if valid file with notice flash" do
      file = fixture_file_upload('example.jpg', 'text/jpg')
      patch :update, id: purchase.transaction_id, purchase: { receipt: file }
      purchase.reload # need to reload the class to get changes
      expect(purchase.receipt.file.file).to be_present
      expect(purchase.status).to eql PurchaseStatus::CONFIRMED
      expect(response).to redirect_to root_path
      expect(flash[:notice]).to be_present
    end

    it "returns to purchase_path if empty file with alert flash" do
      patch :update, id: purchase.transaction_id, purchase: { receipt: '' }
      expect(purchase.receipt).to_not be_present
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end
  end

end
