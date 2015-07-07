require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "massive_reset_password" do
    let(:user) { User.make! }
    let(:mail) { UserMailer.massive_reset_password(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Recuperação de senha")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["no-reply@triboviva.com.br"])
    end
  end

end
