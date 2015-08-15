ActiveAdmin.register Purchase do
  permit_params :status, :total, :taxes, :receipt

  show do
    attributes_table do
      row :user
      row :token
      row :status
      row :taxes do |purchase|
        number_to_currency purchase.taxes
      end
      row :total do |purchase|
        number_to_currency purchase.total_with_taxes
      end
    end

    panel 'Itens desta compra' do
      table_for purchase.orders do
        column :offer
        column :quantity
        column :offer_value do |order|
          number_to_currency order.offer_value
        end
      end
    end
  end
end
