class DeliverCoordinator < ActiveRecord::Base
  has_many :offers

  validates :cpf, :name, :phone, :email, :avatar, :address, :partial_address,
            presence: true

  mount_uploader :avatar, DeliverCoordinatorUploader
end
