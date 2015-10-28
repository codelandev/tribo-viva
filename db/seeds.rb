# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development? || Rails.env.staging?
  printf "====== Creating consumers ... "

  10.times do |index|
    User.create!(name: "User Test #{index+1}", email: "user_#{index+1}@test.com",
                cpf: "0000000000#{index+1}", phone: "51377897#{index+10}",
                address: "Rua do usuário comum", password: '123123123')
  end

  printf "DONE! ======\n\n"
  printf "====== Creating Producers & Deliver Coordinators ... "

  10.times do |index|
    Producer.create!(name: "Produtor #{index}",
                    phone: "321321321",
                    email: "email_do_produtor_#{index}@test.com",
                    address: "Rua do Produtor #{index}",
                    description: "Lorem ipsum Et incididunt culpa ad esse adipisicing anim sed ex minim exercitation sint magna sunt aliquip culpa ad velit dolore officia magna dolore eu id dolore Ut nostrud ut Ut sint id occaecat consectetur cillum ut culpa est dolore exercitation nostrud in laboris do ut id cupidatat et fugiat in et ex sunt tempor nisi Duis eu esse ad ut ex enim non aute in eu eu amet est aliqua veniam exercitation in sed eiusmod aliquip non aliqua sunt Excepteur labore et qui amet laboris aute esse voluptate veniam irure cillum consectetur sed enim officia ea nisi Excepteur non Ut irure incididunt adipisicing ullamco ut aute elit officia fugiat Duis mollit velit reprehenderit sint et do voluptate Ut proident incididunt in minim reprehenderit magna non et anim aliquip eiusmod ullamco ut velit reprehenderit magna nostrud sint dolor in sit in Duis ullamco esse ea eiusmod non in Duis sint aliquip commodo dolor sed est in magna anim eu Duis dolore labore voluptate aliquip velit veniam non incididunt deserunt Ut commodo deserunt ex commodo et id sunt sint ut veniam commodo deserunt tempor occaecat occaecat aute ea id qui qui eiusmod nisi ex est pariatur veniam occaecat aute deserunt sint esse magna nulla Excepteur sit in ex.",
                    contact_name: "Contato Produtor #{index}",
                    logo: File.open('spec/support/example.jpg'))

    DeliverCoordinator.create!(name: "Coordenador #{index}",
                              phone: "321321321",
                              email: "email_do_coordenador_#{index}@test.com",
                              address: "Rua do coordenador #{index}",
                              partial_address: "Rua do coordenador",
                              cpf: "00914969000",
                              avatar: File.open('spec/support/example.jpg'))
  end

  printf "DONE! ======\n\n"
  printf "====== Creating Example Bank Accounts ... "

  BankAccount.create!(cc: '01014278-0', bank: 'Santander', agency: '1208', bank_number: '001',
                     operation_code: '002', owner_name: 'John Doe', cnpj_cpf: '000000000000')

  printf "DONE! ======\n\n"
  printf "====== Creating Example Offers ... "

  3.times do |index|
    Offer.create!(deliver_coordinator: DeliverCoordinator.last,
                 bank_account: BankAccount.last,
                 producer: Producer.last,
                 title: "Oferta Nº #{index+1}",
                 image: File.open('spec/support/example.jpg'),
                 value: 49.90,
                 stock: 10,
                 products_description: "Lorem ipsum Velit minim laboris sint pariatur reprehenderit veniam do quis qui anim ad irure laborum in sint ad est ex id ad ex commodo Duis aliquip aliqua et reprehenderit sed ut culpa laboris culpa ex do ex labore nulla cillum.",
                 operational_tax: 4.99,
                 coordinator_tax: 4.99,
                 offer_starts_at: 1.day.from_now,
                 offer_ends_at: 9.day.from_now,
                 collect_starts_at: 10.day.from_now,
                 collect_ends_at: 20.days.from_now)

    5.times do |index2|
      user  = User.find(index2+1)
      offer = Offer.last
      OldPurchase.create!(user: user, offer: offer, amount: 1, status: OldPurchaseStatus::CONFIRMED,
                      receipt: File.open('spec/support/example.jpg'))
      Purchase.create!(user: user, status: 'paid', total: 0, invoice_id: index2.to_s+"32UH13I21H312IU")
      Order.create!(offer: offer, purchase: Purchase.last, offer_value: offer.value, quantity: 3)
    end
  end

  printf "DONE! ======\n\n"
end
