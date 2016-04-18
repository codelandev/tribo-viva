ActiveAdmin.register Purchase do
  filter :status, as: :select
  filter :user_name, as: :string

  permit_params :status, :total, :taxes, :receipt

  index do
    selectable_column
    id_column
    column :user
    column :created_at
    column :status do |purchase|
      purchase.status_humanize
    end
    column :payment_method do |purchase|
      case purchase.payment_method
      when 'credit_card'
        'Cartão'
      when 'bank_slip'
        'Boleto'
      when 'transfer'
        'Transferência'
      end
    end
    column :total do |purchase|
      purchase.total_with_taxes
    end
    actions
  end

  show do
    attributes_table do
      row :user
      row :invoice_id
      row :status
      row :taxes do |purchase|
        number_to_currency purchase.taxes
      end
      row :receipt do |purchase|
        link_to(purchase.receipt.url, purchase.receipt.url, target: :blank) if purchase.receipt?
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
        column 'Valor total da cota' do |order|
          number_to_currency order.offer_value*order.quantity
        end
      end
    end
  end
end
