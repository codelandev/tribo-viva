class OldPurchase < ActiveRecord::Base
  attr_accessor :user_status, :registered_user_email, :unregistered_user_name, :unregistered_user_email,
                :unregistered_user_cpf, :unregistered_user_phone, :unregistered_user_address

  before_validation :generate_transaction_id, on: :create

  belongs_to :user
  belongs_to :offer

  validates :user, :amount, :status, presence: true
  validates :receipt, presence: true, on: :update

  scope :pending, -> { where(status: OldPurchaseStatus::PENDING) }
  scope :canceled, -> { where(status: OldPurchaseStatus::CANCELED) }
  scope :confirmed, -> { where(status: OldPurchaseStatus::CONFIRMED) }

  has_enumeration_for :status, with: OldPurchaseStatus, create_helpers: true

  mount_uploader :receipt, PurchaseUploader

  def to_param
    transaction_id
  end

  def confirm!
    update_attributes(status: OldPurchaseStatus::CONFIRMED)
  end

  def cancel!
    update_attributes(status: OldPurchaseStatus::CANCELED)
  end

  def total
    offer.value * amount
  end

  protected

  def generate_transaction_id
    self.transaction_id = SecureRandom.hex if transaction_id.blank?
  end
end
