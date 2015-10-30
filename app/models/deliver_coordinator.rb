class DeliverCoordinator < ActiveRecord::Base
  has_many :offers
  has_many :purchases, as: :user

  validates :cpf, :name, :phone, :email, :avatar, :address, :partial_address,
            :neighborhood, presence: true

  mount_uploader :avatar, DeliverCoordinatorUploader
end
