class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :user, :status, :total, presence: true

  # Check PurchaseStatus class to all statuses availables
  scope :by_status, -> (status) { where(status: status) }

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
end
