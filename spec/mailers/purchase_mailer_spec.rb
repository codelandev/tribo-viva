require "rails_helper"

RSpec.describe PurchaseMailer, type: :mailer do
  describe ".confirm" do
    let!(:purchase) { Purchase.make!(:confirmed) }
    let!(:mail) { PurchaseMailer.confirm(purchase) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirmação de compra Tribo Viva")
      expect(mail.to).to eq([purchase.user.email])
      expect(mail.from).to eq(["confirmacao@triboviva.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Olá #{purchase.user.name}")
      expect(mail.body.encoded).to match("Sua compra está pendente de pagamento, assim que o tiver, por favor, faça upload do comprovante no seguinte link")
      expect(mail.body.encoded).to match("#{purchase_url(purchase.transaction_id)}")
    end
  end

end
