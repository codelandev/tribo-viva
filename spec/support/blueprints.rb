require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

User.blueprint do
  cpf { '12345678901' }
  name { 'User Test' }
  email { 'user@test.com' }
  phone { '(51) 3779-9710' }
  address { 'Felipe Neri, 128' }
end

Producer.blueprint do
  name { "Produtor" }
  phone { "321321321" }
  email { "email_do_produtor@test.com" }
  address { "Rua do Produtor" }
  description { "Lorem ipsum." }
  contact_name { "Contato Produtor" }
  logo { File.open('spec/support/example.jpg') }
end

DeliverCoordinator.blueprint do
  name { "Coordenador" }
  phone { "321321321" }
  email { "email_do_coordenador@test.com" }
  address { "Rua do coordenador completa" }
  partial_address { "Rua do coordenador" }
  cpf { "000.000.000-00" }
  avatar { File.open('spec/support/example.jpg') }
end

BankAccount.blueprint do
  cc { '01014278-0' }
  bank { 'Santander' }
  agency { '1208' }
  cnpj_cpf { '0000000000' }
  owner_name { 'Dono da Conta Bancária' }
  bank_number { '001' }
  operation_code { '002' }
end

Offer.blueprint do
  producer
  deliver_coordinator
  bank_account
  title { "Oferta" }
  image { File.open('spec/support/example.jpg') }
  value { 49.90 }
  stock { 10 }
  products_description { "Lorem ipsum." }
  operational_tax { 4.99 }
  coordinator_tax { 4.99 }
  offer_starts_at { 1.day.from_now }
  offer_ends_at { 9.day.from_now }
  collect_starts_at { 10.day.from_now }
  collect_ends_at { 20.days.from_now }
end

Purchase.blueprint(:pending) do
  user
  offer
  amount { 2 }
  status { PurchaseStatus::PENDING }
end

Purchase.blueprint(:confirmed) do
  user
  offer
  amount { 2 }
  status { PurchaseStatus::CONFIRMED }
  receipt { File.open('spec/support/example.jpg') }
end

Purchase.blueprint(:canceled) do
  user
  offer
  amount { 2 }
  status { PurchaseStatus::CANCELED }
  receipt { File.open('spec/support/example.jpg') }
end
