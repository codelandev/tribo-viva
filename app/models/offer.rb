class Offer < ActiveRecord::Base
  belongs_to :producer
  belongs_to :bank_account
  belongs_to :deliver_coordinator
  has_many :old_purchases
  has_many :orders
  has_many :purchases, through: :orders

  validates :deliver_coordinator, :bank_account, :producer, :title, :image, :value, :stock,
            :products_description, :offer_ends_at, :operational_tax, :coordinator_tax,
            :collect_ends_at, :offer_starts_at, :collect_starts_at, presence: true

  mount_uploader :image, OfferUploader

  scope :valid_offers, -> { where('offer_ends_at > ? AND stock > 0', DateTime.now) }
  scope :finished_offers, -> { where('offer_ends_at < ? OR stock <= 0', DateTime.now) }

  def total
    coordinator_tax + operational_tax + value
  end

  def delivery_time_range
    "#{I18n.l(collect_starts_at, format: :long)} até #{collect_ends_at.strftime('%H:%M')}"
  end

  def remaining
    stock - Purchase.joins(:orders)
                    .where(status: PurchaseStatus::PAID,
                           orders:{offer_id: self.id})
                    .sum(:quantity) - 1
  end

  def is_valid_offer?
    0 >= remaining && DateTime.now < offer_ends_at
  end
end
