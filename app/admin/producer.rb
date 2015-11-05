ActiveAdmin.register Producer do
  permit_params :name, :address, :logo, :description, :contact_name, :phone, :email, :cover_image, :video_url, :certification

  menu priority: 6

  index do
    column :id
    column :logo do |producer|
      image_tag producer.logo.url, size: '100x100'
    end
    column :name
    column :email
    column :phone
    column :address
    column :contact_name
    actions
  end

  show do
    attributes_table do
      row :logo do
        image_tag producer.logo.url, size: '100x100'
      end
      row :name
      row :phone
      row :email
      row :address
      row :contact_name
      row :description do
        simple_format producer.description
      end
    end
  end

  form do |f|
    f.inputs "Conteúdo 'Cover'" do
      f.input :logo
      f.input :cover_image
      f.input :name
      f.input :phone
      f.input :email
      f.input :address
      f.input :contact_name
      f.input :certification
      f.input :video_url
      f.input :description, as: :html_editor
    end

    f.actions
  end
end
