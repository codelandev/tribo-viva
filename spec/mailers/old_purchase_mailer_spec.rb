require "rails_helper"

RSpec.describe OldPurchaseMailer, type: :mailer do
  describe ".pending_payment" do
    let!(:purchase) { OldPurchase.make!(:pending) }
    let!(:mail) { OldPurchaseMailer.pending_payment(purchase) }

    it "renders the headers" do
      expect(mail.subject).to eq("Pague sua compra e envie o comprovante")
      expect(mail.to).to eq([purchase.user.email])
      expect(mail.from).to eq(["confirmacao@triboviva.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Oi, #{purchase.user.name}")
      expect(mail.body.encoded).to match("#{old_purchase_url(purchase.transaction_id)}")
    end
  end

  describe ".confirmed_payment" do
    let!(:purchase) { OldPurchase.make!(:confirmed) }
    let!(:mail) { OldPurchaseMailer.confirmed_payment(purchase) }

    it "renders the headers" do
      expect(mail.subject).to eq("Compra confirmada")
      expect(mail.to).to eq([purchase.user.email])
      expect(mail.from).to eq(["confirmacao@triboviva.com.br"])
    end
  end
end
