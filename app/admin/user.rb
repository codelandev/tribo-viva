ActiveAdmin.register User do
  filter :email
  filter :name
  filter :cpf

  permit_params :cpf, :name, :email, :phone, :address, :password
  menu priority: 3

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :sign_in_count
    column :created_at
    actions
  end

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
