class Offer < ActiveRecord::Base
  after_create :create_coordinator_reservation

  belongs_to :producer
  belongs_to :bank_account
  belongs_to :deliver_coordinator
  has_many :old_purchases
  has_many :orders
  has_many :purchases, through: :orders
  has_many :offer_items, dependent: :destroy

  accepts_nested_attributes_for :offer_items, allow_destroy: true, reject_if: :all_blank

  validates :deliver_coordinator, :bank_account, :producer, :title, :image, :value, :stock,
            :description, :offer_ends_at, :operational_tax, :coordinator_tax,
            :collect_ends_at, :offer_starts_at, :collect_starts_at, presence: true

  mount_uploader :image, OfferUploader

  scope :valid_offers, -> { where('? < offer_ends_at AND 0 < stock', DateTime.now) }
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
                    .sum(:quantity)
  end

  def is_valid_offer?
    0 < remaining && DateTime.now < offer_ends_at
  end

  def can_pay_with_bank_slip?
    # Now must be BEFORE the last valid business day of the ogger
    DateTime.now < 2.business_days.before(offer_ends_at)
  end

  private

  def create_coordinator_reservation
    purchase = Purchase.new(status: PurchaseStatus::PAID,
                            user: deliver_coordinator,
                            invoice_id: SecureRandom.hex(32))
    purchase.orders.build(offer: self, quantity: 1, offer_value: 0)
    purchase.save
  end
end
