require "rails_helper"

RSpec.describe Remembers, type: :mailer do
  describe "producer" do
    let(:mail) { Remembers.producer }

    it "renders the headers" do
      expect(mail.subject).to eq("Producer")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "deliver_coordinator" do
    let(:mail) { Remembers.deliver_coordinator }

    it "renders the headers" do
      expect(mail.subject).to eq("Deliver coordinator")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "buyer" do
    let(:mail) { Remembers.buyer }

    it "renders the headers" do
      expect(mail.subject).to eq("Buyer")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
