class Purchase < ActiveRecord::Base
  belongs_to :user, polymorphic: true
  has_many :orders, dependent: :destroy
  has_many :offers, through: :orders

  validates :user, :status, :total, :invoice_id, presence: true

  # Check PurchaseStatus class to all statuses availables
  scope :by_status, -> (status) { where(status: status) }

  has_enumeration_for :status, with: PurchaseStatus, create_helpers: true

  mount_uploader :receipt, PurchaseUploader

  def total_with_taxes
    total + taxes
  end

  def confirm!
    update_attributes(status: PurchaseStatus::PAID)
  end

  def cancel!
    update_attributes(status: PurchaseStatus::CANCELED)
  end

  def has_invalid_offers?
    offers.finished_offers.any?
  end
end
