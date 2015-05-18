class DeliverCoordinator < ActiveRecord::Base
  validates :cpf, :name, :phone, :email, :avatar, :address, presence: true

  mount_uploader :avatar, DeliverCoordinatorUploader
end
