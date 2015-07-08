ActiveAdmin.register Purchase do
  permit_params :status, :total

  show do
    attributes_table do
      row :user
      row :token
      row :status
      row :total do |purchase|
        number_to_currency purchase.total
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
