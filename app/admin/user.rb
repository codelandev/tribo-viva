ActiveAdmin.register User do
  permit_params :cpf, :name, :email, :phone, :address
end
