class UserMailer < ApplicationMailer
  def massive_reset_password(user)
    @user = user
    @token, enc = Devise.token_generator.generate(User, :reset_password_token)
    @user.reset_password_token   = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save(validate: false)

    mail to: user.email, subject: 'Recuperação de senha'
  end
end
