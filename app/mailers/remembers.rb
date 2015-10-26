class Remembers < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.remembers.producer.subject
  #
  def producer(producer, offers)
    @offers = offers
    @producer = producer
    @day = Date.tomorrow
    mail to: producer.email, subject: "Entregas tribo-viva", bcc: 'tribo@triboviva.com.br'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.remembers.deliver_coordinator.subject
  #
  def deliver_coordinator(offer)
    @offer = offer
    @deliver_coordinator = offer.deliver_coordinator
    @purchases = @offer.purchases.by_status(PurchaseStatus::PAID).includes(:orders)
    @day = Date.today
    mail to: @deliver_coordinator.email, subject: "Lembrete de entregas tribo-viva", bcc: 'tribo@triboviva.com.br'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.remembers.buyer.subject
  #
  def buyer(user, offer)
    @user = user
    @offer = offer
    @day = Date.today
    mail to: user.email, subject: "Lembrete de coletas tribo-viva", bcc: 'tribo@triboviva.com.br'
  end
end
