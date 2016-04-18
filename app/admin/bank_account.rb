ActiveAdmin.register BankAccount do
  permit_params :cc, :bank, :agency, :bank_number, :operation_code, :owner_name,
    :cnpj_cpf
  menu priority: 4

  config.filters = false

  index do
    column :id
    column :cc
    column :bank
    actions
  end
end
