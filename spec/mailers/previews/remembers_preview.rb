# Preview all emails at http://localhost:3000/rails/mailers/remembers
class RemembersPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/remembers/producer
  def producer
    Remembers.producer
  end

  # Preview this email at http://localhost:3000/rails/mailers/remembers/deliver_coordinator
  def deliver_coordinator
    Remembers.deliver_coordinator
  end

  # Preview this email at http://localhost:3000/rails/mailers/remembers/buyer
  def buyer
    Remembers.buyer
  end

end
