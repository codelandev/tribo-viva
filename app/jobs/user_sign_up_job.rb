class UserSignUpJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    customer = Iugu::Customer.create(
      cpf_cnpj: user.cpf.gsub(/[\.-]/, ''),
      email: user.email,
      name: user.name
    )
    user.update_attribute(:iugu_customer, customer.id)
    user.purchases.where(payment_method: [:bank_slip, :credit_card]).pluck(:invoice_id).each do |id|
      invoice = Iugu::Invoice.fetch(id)
      invoice.customer_id = user.iugu_customer
      invoice.save
    end
  end
end
