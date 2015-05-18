ActiveAdmin.register DeliverCoordinator do
  permit_params :cpf, :name, :phone, :email, :avatar, :address

  index do
    column :id
    column :avatar do |coordinator|
      image_tag coordinator.avatar.url, size: '100x100'
    end
    column :name
    column :email
    column :cpf
    column :phone
    column :address
    actions
  end

  show do
    attributes_table do
      row :avatar do
        image_tag deliver_coordinator.avatar.url, size: '200x200'
      end
      row :name
      row :phone
      row :email
      row :address
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
      f.input :cpf
    end

    f.actions
  end
end
