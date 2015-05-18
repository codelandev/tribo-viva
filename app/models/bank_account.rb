class BankAccount < ActiveRecord::Base
  has_many :offers

  validates :cc, :bank, :agency, :bank_number, :operation_code, presence: true
end
