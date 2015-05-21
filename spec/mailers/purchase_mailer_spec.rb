require "rails_helper"

RSpec.describe PurchaseMailer, type: :mailer do
  pending ".confirm" do
    let(:mail) { PurchaseMailer.confirm }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
