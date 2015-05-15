class Producer < ActiveRecord::Base
  validates :name, :address, :logo, :description, :contact_name, :phone, :email, presence: true

  mount_uploader :logo, ProducerUploader
end
