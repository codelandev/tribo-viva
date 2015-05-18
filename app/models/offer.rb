class Offer < ActiveRecord::Base
  belongs_to :deliver_coordinator
  belongs_to :bank_account
  belongs_to :producer

  validates :deliver_coordinator, :bank_account, :producer, :title, :image, :value, :stock,
            :products_description, :offer_ends_at, :operational_tax, :coordinator_tax,
            :collect_ends_at, :offer_starts_at, :collect_starts_at, presence: true

  mount_uploader :image, OfferUploader
end
