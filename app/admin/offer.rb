ActiveAdmin.register Offer do
  permit_params :deliver_coordinator_id, :bank_account_id, :producer_id, :title, :image, :value, :stock,
                :description, :offer_ends_at, :operational_tax, :coordinator_tax,
                :collect_ends_at, :offer_starts_at, :collect_starts_at,
                offer_items_attributes:[:id, :name, :unit, :quantity, :unit_price, :_destroy]

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
      "Restam #{offer.remaining} de #{offer.stock}"
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
        "Restam #{offer.remaining} de #{offer.stock}"
      end
      row :description do |offer|
        simple_format offer.description
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

    panel 'Items da oferta' do
      table_for offer.offer_items.order(name: :asc) do
        column :name do |item|
          item.name
        end
        column :unit do |item|
          OfferItemUnit.t item.unit
        end
        column :quantity do |item|
          item.quantity
        end
        column :unit_price do |item|
          number_to_currency item.unit_price
        end
        column :total do |item|
          number_to_currency item.total
        end
      end
    end

    panel 'Compras com esta oferta' do
      table_for offer.purchases.order(status: :desc) do
        column :invoice_id do |purchase|
          link_to purchase.invoice_id, admin_purchase_path(purchase)
        end
        column :status do |purchase|
          PurchaseStatus.t purchase.status
        end
        column :user
        column :total do |purchase|
          number_to_currency purchase.total
        end
      end
    end
  end

  form do |f|
    f.inputs do
      image_tag offer.image.url, size: '150x150'
      f.input :producer, collection: Producer.order(name: :asc)
      f.input :bank_account, collection: BankAccount.all.map{|w| [w.bank, w.id]}, include_blank: false
      f.input :deliver_coordinator, collection: DeliverCoordinator.order(name: :asc)
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image.url, size: '200x200') : content_tag(:span, "Nenhuma imagem presente.")
      f.input :title
      f.input :value, label: 'Valor da Cota'
      f.input :operational_tax
      f.input :coordinator_tax
      f.input :stock
      f.input :description, as: :html_editor
      f.input :offer_starts_at
      f.input :offer_ends_at
      f.input :collect_starts_at
      f.input :collect_ends_at

      panel '' do
        f.has_many :offer_items do |a|
          a.input :name
          a.input :unit, as: :select, collection: OfferItemUnit.to_a
          a.input :quantity
          a.input :unit_price
          a.input :_destroy, as: :boolean, label: 'Remover?'
        end
      end
    end

    f.actions
  end
end
