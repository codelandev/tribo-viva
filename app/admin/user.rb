ActiveAdmin.register User do
  permit_params :cpf, :name, :email, :phone
  menu priority: 3
end
