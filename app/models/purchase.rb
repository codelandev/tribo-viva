class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :user, :status, :total, presence: true

  # Check PurchaseStatus class to all statuses availables
  scope :by_status, -> (status) { where(status: status) }

  def total
    orders.sum("quantity * offer_value").to_f
  end
end
