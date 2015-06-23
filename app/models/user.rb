class User < ActiveRecord::Base
  has_many :purchases

  validates :cpf, :name, :email, :phone, presence: true
end
