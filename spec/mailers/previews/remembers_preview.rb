# Preview all emails at http://localhost:3000/rails/mailers/remembers
class RemembersPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/remembers/producer
  def producer
    offer = Offer.all.order('RANDOM()').first
    producer = offer.producer
    Remembers.producer(producer, [offer])
  end

  # Preview this email at http://localhost:3000/rails/mailers/remembers/deliver_coordinator
  def deliver_coordinator
    offer = Offer.all.order('RANDOM()').first
    Remembers.deliver_coordinator(offer)
  end

  # Preview this email at http://localhost:3000/rails/mailers/remembers/buyer
  def buyer
    user = User.last
    offer = Offer.all.order('RANDOM()').first
    Remembers.buyer(user, offer)
  end

end
