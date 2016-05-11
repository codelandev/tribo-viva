ActiveAdmin.register_page "Faturamento" do
  menu priority: 2
  content do
    columns do
      column do
        panel "Faturamento Ofertas" do
          offers = Offer.all.reverse

          table_for offers do
            th "N"
            th "Produtor"
            th "Data"
            th "Bairro"
            th "Coordenador"
            th "Cota"
            th "C. Vend."
            th "Prod"
            th "Tribo"
            th "Coord"
            th "Cota"
            th "T. Prod."
            th "T. Tribo"
            th "T. Coord"
            th "Total"
            th "Lucro"
            offers.each do |offer|
              tr do
                  td offer.id
                  td offer.producer.name
                  td offer.collect_starts_at.strftime('%d/%m/%Y')
                  td offer.deliver_coordinator.neighborhood
                  td offer.deliver_coordinator.name
                  td offer.stock
                  td offer.stock - offer.remaining
                  td number_to_currency(offer.value)
                  td number_to_currency(offer.operational_tax)
                  td number_to_currency(offer.coordinator_tax)
                  td number_to_currency(offer.total)
                  td number_to_currency(offer.total*((offer.stock - offer.remaining)+1))
                  td number_to_currency(offer.operational_tax * (offer.stock - offer.remaining))
                  td number_to_currency(offer.coordinator_tax * (offer.stock - offer.remaining))
                  td number_to_currency(((offer.total*(((offer.stock - offer.remaining)+1))-offer.value))+
                  offer.operational_tax * (offer.stock - offer.remaining)+
                  offer.coordinator_tax * (offer.stock - offer.remaining))
                  td number_to_currency((offer.coordinator_tax * (offer.stock - offer.remaining) - offer.value)+(offer.operational_tax * (offer.stock - offer.remaining)))
                  #+(offer.operational_tax * (offer.stock - offer.remaining)))
              end
            end
          end
        end
      end
    end
  end
end
