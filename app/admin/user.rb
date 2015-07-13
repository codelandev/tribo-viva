ActiveAdmin.register User do
  permit_params :cpf, :name, :email, :phone, :address, :password
  menu priority: 3

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.input :cpf
      f.input :phone
      f.input :address
      f.input :password
    end
    f.actions
  end
end
