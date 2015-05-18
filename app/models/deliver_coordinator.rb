class DeliverCoordinator < ActiveRecord::Base
  has_many :offers

  validates :cpf, :name, :phone, :email, :avatar, :address, presence: true

  mount_uploader :avatar, DeliverCoordinatorUploader
end
