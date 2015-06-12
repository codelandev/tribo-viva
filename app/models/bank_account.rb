class BankAccount < ActiveRecord::Base
  has_many :offers

  validates :cc, :bank, :agency, :bank_number, :operation_code, :cnpj_cpf,
            :owner_name, presence: true
end
