class User < ActiveRecord::Base
  has_many :purchases

  validates :cpf, :name, :email, presence: true
  # validates :cpf, uniqueness: { scope: :email }
  # validates :email, uniqueness: { scope: :cpf }
end
