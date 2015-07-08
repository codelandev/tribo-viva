class OldPurchaseForm
  include ActiveModel::Model

  attr_accessor :user, :purchase, :email, :cpf, :name, :phone, :address, :amount

  validates :email, :cpf, :name, :phone, :address, presence: true, unless: :exist_user?
  validates :user, :purchase, presence: true

  def initialize(offer, params={})
    @user = User.find_or_initialize_by(email: params[:email]) do |u|
      u.cpf = params[:cpf]
      u.name = params[:name]
      u.phone = params[:phone]
      u.address = params[:address]
    end
    @purchase = OldPurchase.new(amount: params[:amount], user: user, offer: offer)
    super params
  end

  def save
    return false unless valid? && user.valid? && purchase.valid?
    user.save && purchase.save
    OldPurchaseMailer.pending_payment(purchase).deliver_now
    true
  end

  private

  def exist_user?
    user.persisted?
  end
end
