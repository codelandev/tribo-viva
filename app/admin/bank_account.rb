ActiveAdmin.register BankAccount do
  permit_params :cc, :bank, :agency, :bank_number, :operation_code
end
