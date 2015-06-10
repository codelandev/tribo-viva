class AddOwnerNameAndCnpjCpfToBankAccounts < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :owner_name, :string
    add_column :bank_accounts, :cnpj_cpf, :string
  end
end
