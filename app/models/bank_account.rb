class BankAccount < ActiveRecord::Base
  validates :cc, :bank, :agency, :bank_number, :operation_code, presence: true
end
