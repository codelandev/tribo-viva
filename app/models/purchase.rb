class Purchase < ActiveRecord::Base
  has_secure_token

  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :user_id, :status, :total, presence: true
end
