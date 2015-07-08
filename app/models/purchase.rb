class Purchase < ActiveRecord::Base
  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :user_id, :token, :status, :total, presence: true
end
