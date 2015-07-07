# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/massive_reset_password
  def massive_reset_password
    UserMailer.massive_reset_password(User.first)
  end
end
