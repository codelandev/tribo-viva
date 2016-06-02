ActiveAdmin.register Offer do
  filter :producer
  filter :offer_starts_at
  filter :offer_ends_at

  permit_params :deliver_coordinator_id, :bank_account_id, :producer_id, :title, :image, :value, :stock,
                :description, :offer_ends_at, :operational_tax, :coordinator_tax,
                :collect_ends_at, :offer_starts_at, :collect_starts_at,
                :image_cache,
                offer_items_attributes: [
                  :id,
                  :name,
                  :unit,
                  :quantity,
                  :unit_price,
                  :_destroy,
                  :offer_starts_at_time,
                  :offer_ends_at_time,
                  :collect_starts_at_time,
                  :collect_ends_at_time
                ]

  menu priority: 7

  before_save do |offer|
    total_sum = 0
    offer.offer_items.map{|i| total_sum = total_sum+i.total}
    offer.value = total_sum
    offer.operational_tax = offer.value * 0.20
    offer.coordinator_tax = offer.value * 0.10
    offer.save
  end

  action_item only: :show do
    link_to('Duplicar', new_admin_offer_path(offer_id: offer.id))
  end

  controller do
    def new
      if params[:offer_id].present?
        offer = Offer.find(params[:offer_id])
        @offer = offer.dup
        @offer.image = offer.image
        @offer.offer_items << offer.offer_items.collect { |item| item.dup }
      end
      super
    end
  end

  index do
    column :id
    column :title
    column :image do |offer|
      image_tag offer.image.url(:admin_thumb)
    end
    column :value do |offer|
      number_to_currency offer.value
    end
    column :stock do |offer|
      "Restam #{offer.remaining} de #{offer.stock}"
    end
    column :offer_starts_at
    actions defaults: true do |offer|
      link_to('Duplicar', new_admin_offer_path(offer_id: offer.id))
    end
  end

  show do
    attributes_table do
      row :image do |offer|
        image_tag offer.image.url(:admin_thumb)
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
        column :user
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
        column :invoice_id do |purchase|
          link_to purchase.invoice_id, admin_purchase_path(purchase)
        end
        column :total do |purchase|
          number_to_currency purchase.total
        end
        column :quantity do |purchase|
          purchase.orders.where(offer: offer).sum(:quantity)
        end
      end
    end
  end

  form do |f|
    def time_setting_from_datetime(form, attribute)
      datetime = form.object.public_send(attribute)
      value = form.object.public_send("#{attribute}_time") ||
        datetime && "#{datetime.hour}:#{datetime.min}"
      form.input "#{attribute}_time",
        as: :string,
        label: false,
        wrapper_html: { class: 'time_picker_wrapper' },
        input_html: {
          value: value,
          class: 'time_picker',
          maxlength: 5
        }
    end

    f.inputs do
      image_tag offer.image.url(:admin_thumb)
      f.input :producer, collection: Producer.order(name: :asc)
      f.input :bank_account, collection: BankAccount.all.map{|w| [w.bank, w.id]}, include_blank: false
      f.input :deliver_coordinator, collection: DeliverCoordinator.order(name: :asc)
      f.input :image,
        as: :file,
        hint: f.object.image.present? ?
          image_tag(f.object.image.url(:admin_thumb)) :
          content_tag(:span, "Nenhuma imagem presente.")
      f.input :image_cache, as: :hidden
      f.input :title
      f.input :stock
      f.input :description, as: :html_editor
      columns do
        column do
          f.input :offer_starts_at, as: :date_picker
          time_setting_from_datetime(f, 'offer_starts_at')
        end
        column do
          f.input :offer_ends_at, as: :date_picker
          time_setting_from_datetime(f, 'offer_ends_at')
        end
        column do
          f.input :collect_starts_at, as: :date_picker
          time_setting_from_datetime(f, 'collect_starts_at')
        end
        column do
          f.input :collect_ends_at, as: :date_picker
          time_setting_from_datetime(f, 'collect_ends_at')
        end
      end

      panel '' do
        f.has_many :offer_items, allow_destroy: true do |a|
          a.input :name
          a.input :unit, as: :select, collection: OfferItemUnit.to_a
          a.input :quantity
          a.input :unit_price
        end
      end
    end

    f.actions
  end

  controller do
    def create
      parse_datetime_params
      super
    end

    def update
      parse_datetime_params
      super
    end

    def parse_datetime_params
      Offer::TIME_ATTRIBUTES.each do |attribute|
        date = params[:offer][attribute]
        time = params[:offer]["#{attribute}_time"]
        params[:offer][attribute] = "#{date} #{time}"
      end
    end
  end
end
