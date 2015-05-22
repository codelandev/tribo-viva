class Offer < ActiveRecord::Base
  belongs_to :producer
  belongs_to :bank_account
  belongs_to :deliver_coordinator
  has_many :purchases

  validates :deliver_coordinator, :bank_account, :producer, :title, :image, :value, :stock,
            :products_description, :offer_ends_at, :operational_tax, :coordinator_tax,
            :collect_ends_at, :offer_starts_at, :collect_starts_at, presence: true

  mount_uploader :image, OfferUploader

  scope :valid_offers, -> { where('offer_ends_at > ? AND stock > 0', DateTime.now) }
  scope :finished_offers, -> { where('offer_ends_at < ? OR stock <= 0', DateTime.now) }

  def remaining
    stock - purchases.where(status: [PurchaseStatus::PENDING, PurchaseStatus::CONFIRMED]).count
  end
end