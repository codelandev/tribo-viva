ActiveAdmin.register DeliverCoordinator do
  filter :name
  filter :email

  permit_params :cpf, :name, :phone, :email, :avatar, :address, :partial_address,
                :neighborhood

  menu priority: 5

  index do
    column :id
    column :avatar do |coordinator|
      image_tag coordinator.avatar.url(:admin_thumb)
    end
    column :name
    column :email
    column :phone
    column :address
    actions
  end

  show do
    attributes_table do
      row :avatar do
        image_tag deliver_coordinator.avatar.url(:admin_thumb)
      end
      row :name
      row :phone
      row :email
      row :address
      row :neighborhood
      row :partial_address
      row :cpf
    end
  end

  form do |f|
    f.inputs do
      f.input :avatar
      f.input :name
      f.input :phone
      f.input :email
      f.input :address
      f.input :neighborhood
      f.input :partial_address
      f.input :cpf
    end

    f.actions
  end
end
