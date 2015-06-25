require "rails_helper"

RSpec.describe PurchaseMailer, type: :mailer do
  describe ".pending_payment" do
    let!(:purchase) { Purchase.make!(:pending) }
    let!(:mail) { PurchaseMailer.pending_payment(purchase) }

    it "renders the headers" do
      expect(mail.subject).to eq("Pague sua Compra e envie o comprovante")
      expect(mail.to).to eq([purchase.user.email])
      expect(mail.from).to eq(["confirmacao@triboviva.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Oi, #{purchase.user.name}")
      expect(mail.body.encoded).to match("#{purchase_url(purchase.transaction_id)}")
    end
  end

  describe ".confirmed_payment" do
    let!(:purchase) { Purchase.make!(:confirmed) }
    let!(:mail) { PurchaseMailer.confirmed_payment(purchase) }

    it "renders the headers" do
      expect(mail.subject).to eq("Compra Confirmada")
      expect(mail.to).to eq([purchase.user.email])
      expect(mail.from).to eq(["confirmacao@triboviva.com.br"])
    end
  end
end
