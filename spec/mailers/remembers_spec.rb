require "rails_helper"

RSpec.describe Remembers, type: :mailer do
  let!(:user) { User.make! }
  let!(:producer) { Producer.make!(name: 'cool name for producer') }
  let!(:offer) { Offer.make!(producer: producer) }
  let!(:purchase) { Purchase.make!(user: user) }

  describe "producer" do
    let!(:mail) { Remembers.producer(producer, Offer.all) }

    it "renders the headers" do
      expect(mail.subject).to eq("Entregas tribo-viva")
      expect(mail.to).to eq([producer.email])
      expect(mail.from).to eq(["no-reply@triboviva.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Olá #{producer.name}.")
    end
  end

  describe "deliver_coordinator" do
    let(:mail) { Remembers.deliver_coordinator(offer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Lembrete de entregas tribo-viva")
      expect(mail.to).to eq([offer.deliver_coordinator.email])
      expect(mail.from).to eq(["no-reply@triboviva.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Bom dia, #{offer.deliver_coordinator.name}.")
    end
  end

  describe "buyer" do
    let(:mail) { Remembers.buyer(user, offer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Lembrete de coletas tribo-viva")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@triboviva.com.br"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Bom dia, #{user.name}.")
    end
  end

end
