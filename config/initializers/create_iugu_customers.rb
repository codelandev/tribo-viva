Warden::Manager.after_authentication except: :fetch do |user, auth, opts|
  if user.respond_to?(:iugu_customer) && user.iugu_customer.blank?
    UserSignUpJob.perform_later(user)
  end
end
