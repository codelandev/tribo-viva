class Producer < ActiveRecord::Base
  has_many :offers

  validates :name, :address, :logo, :description, :contact_name, :phone, :email, presence: true

  mount_uploader :logo, ProducerUploader
end
