ActiveAdmin.register BankAccount do
  permit_params :cc, :bank, :agency, :bank_number, :operation_code, :owner_name,
    :cnpj_cpf
end
