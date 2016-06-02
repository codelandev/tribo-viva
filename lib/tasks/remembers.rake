  namespace :remember do
  desc 'Remember producers of tommorows delivers'
  task producers: :environment do
    puts "=== ENVIANDO EMAIL PARA PRODUTORES ... "
    offers = Offer.where(collect_starts_at: Date.today.beginning_of_day..Date.today.end_of_day)
    offers.group_by(&:producer).each do |producer, valid_offers|
      if valid_offers.size > 0
        puts "=== Enviando email produtor #{producer.email} ===\n"
        Remembers.producer(producer, valid_offers).deliver_now
      end
    end
    puts "FIM === \n\n"
  end

  desc 'Remember coordinators of deliveries'
  task coordinators: :environment do
    puts "=== ENVIANDO EMAIL PARA COORDENADORES ... "
    offers = Offer.where(collect_starts_at: Date.today.beginning_of_day..Date.today.end_of_day)
    offers.find_each do |offer|
      puts "=== Enviando email coordenador #{offer.deliver_coordinator.email} ===\n"
      Remembers.deliver_coordinator(offer).deliver_now
    end
    puts "FIM === \n\n"
  end

  desc 'Remember buyers of offers'
  task buyers: :environment do
    puts "=== ENVIANDO EMAIL PARA COMPRADORES ... "
    offers = Offer.where(collect_starts_at: Date.today.beginning_of_day..Date.today.end_of_day)
    offers.find_each do |offer|
      offer.purchases.by_status(PurchaseStatus::PAID).each do |purchase|
        if purchase.user != offer.deliver_coordinator
          puts "=== Enviando email usuário #{purchase.user.email} ===\n"
          Remembers.buyer(purchase.user, offer).deliver_now
        end
      end
    end
    puts "FIM === \n\n"
  end
end
