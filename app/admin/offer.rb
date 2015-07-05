ActiveAdmin.register Offer do
  permit_params :deliver_coordinator_id, :bank_account_id, :producer_id, :title, :image, :value, :stock,
                :products_description, :offer_ends_at, :operational_tax, :coordinator_tax,
                :collect_ends_at, :offer_starts_at, :collect_starts_at

  menu priority: 7

  index do
    column :id
    column :title
    column :image do |offer|
      image_tag offer.image.url, size: '150x150'
    end
    column :value do |offer|
      number_to_currency offer.value
    end
    column :stock do |offer|
      "Resta #{offer.remaining} de #{offer.stock}"
    end
    column :offer_starts_at
    column :offer_ends_at
    column :collect_starts_at
    column :collect_ends_at
    actions
  end

  show do
    attributes_table do
      row :image do |offer|
        image_tag offer.image.url, size: '150x150'
      end
      row :producer
      row :deliver_coordinator
      row :bank_account do |offer|
        offer.bank_account.bank
      end
      row :title
      row :value do |offer|
        number_to_currency offer.value
      end
      row :stock do |offer|
        "Resta #{offer.remaining} de #{offer.stock}"
      end
      row :products_description do |offer|
        simple_format offer.products_description
      end
      row :operational_tax do |offer|
        number_to_currency offer.operational_tax
      end
      row :coordinator_tax do |offer|
        number_to_currency offer.coordinator_tax
      end
      row :offer_starts_at
      row :offer_ends_at
      row :collect_starts_at
      row :collect_ends_at
    end

    panel 'Compras para esta oferta' do
      table_for offer.purchases.order(status: :desc) do
        column :transaction_id do |purchase|
          link_to purchase.transaction_id, admin_purchase_path(purchase)
        end
        column :status do |purchase|
          PurchaseStatus.t purchase.status
        end
        column :user
        column :offer
        column :amount
        column :total do |purchase|
          number_to_currency (purchase.amount * (purchase.offer.value + purchase.offer.operational_tax + purchase.offer.coordinator_tax))
        end
      end
    end
  end

  form do |f|
    f.inputs do
      image_tag offer.image.url, size: '150x150'
      f.input :producer
      f.input :bank_account, collection: BankAccount.all.map{|w| [w.bank, w.id]}, include_blank: false
      f.input :deliver_coordinator
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image.url, size: '200x200') : content_tag(:span, "Nenhuma imagem presente.")
      f.input :title
      f.input :value, label: 'Valor da Cota'
      f.input :operational_tax
      f.input :coordinator_tax
      f.input :stock
      f.input :products_description, as: :html_editor
      f.input :offer_starts_at
      f.input :offer_ends_at
      f.input :collect_starts_at
      f.input :collect_ends_at
    end

    f.actions
  end
end
