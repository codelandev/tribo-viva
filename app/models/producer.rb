class Producer < ActiveRecord::Base
  has_many :offers, dependent: :nullify

  validates :name, :address, :logo, :description, :contact_name, :phone, :email, :cover_image, presence: true

  mount_uploader :logo, ProducerUploader
  mount_uploader :cover_image, ProducerUploader
end
