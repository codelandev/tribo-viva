class User < ActiveRecord::Base
  has_many :purchases

  validates :cpf, :name, :email, :phone, :address, presence: true
end
