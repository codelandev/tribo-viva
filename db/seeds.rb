# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development? || Rails.env.staging?
  10.times do |producer|
    Producer.create(name: "Produtor #{producer}",
                    phone: "321321321",
                    email: "email_do_produtor_#{producer}@test.com",
                    address: "Rua do Produtor #{producer}",
                    description: "Lorem ipsum Et incididunt culpa ad esse adipisicing anim sed ex minim exercitation sint magna sunt aliquip culpa ad velit dolore officia magna dolore eu id dolore Ut nostrud ut Ut sint id occaecat consectetur cillum ut culpa est dolore exercitation nostrud in laboris do ut id cupidatat et fugiat in et ex sunt tempor nisi Duis eu esse ad ut ex enim non aute in eu eu amet est aliqua veniam exercitation in sed eiusmod aliquip non aliqua sunt Excepteur labore et qui amet laboris aute esse voluptate veniam irure cillum consectetur sed enim officia ea nisi Excepteur non Ut irure incididunt adipisicing ullamco ut aute elit officia fugiat Duis mollit velit reprehenderit sint et do voluptate Ut proident incididunt in minim reprehenderit magna non et anim aliquip eiusmod ullamco ut velit reprehenderit magna nostrud sint dolor in sit in Duis ullamco esse ea eiusmod non in Duis sint aliquip commodo dolor sed est in magna anim eu Duis dolore labore voluptate aliquip velit veniam non incididunt deserunt Ut commodo deserunt ex commodo et id sunt sint ut veniam commodo deserunt tempor occaecat occaecat aute ea id qui qui eiusmod nisi ex est pariatur veniam occaecat aute deserunt sint esse magna nulla Excepteur sit in ex.",
                    contact_name: "Contato Produtor #{producer}",
                    remote_logo_url: 'http://theoldreader.com/kittens/200/200/')
  end
end