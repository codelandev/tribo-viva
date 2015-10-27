class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :purchases, dependent: :destroy, as: :user
  has_many :old_purchases, dependent: :destroy

  validates :cpf, :name, :email, :phone, :address, presence: true
end
