class Offer < ActiveRecord::Base
  belongs_to :producer
  belongs_to :bank_account
  belongs_to :deliver_coordinator
  has_many :old_purchases

  validates :deliver_coordinator, :bank_account, :producer, :title, :image, :value, :stock,
            :products_description, :offer_ends_at, :operational_tax, :coordinator_tax,
            :collect_ends_at, :offer_starts_at, :collect_starts_at, presence: true

  mount_uploader :image, OfferUploader

  scope :valid_offers, -> { where('offer_ends_at > ? AND stock > 0', DateTime.now) }
  scope :finished_offers, -> { where('offer_ends_at < ? OR stock <= 0', DateTime.now) }

  def remaining
    stock - old_purchases.where(status: PurchaseStatus::CONFIRMED).map(&:amount).sum
  end

  def delivery_time_range
    "#{I18n.l(collect_starts_at, format: :long)} até #{collect_ends_at.strftime('%H:%M')}"
  end
end
