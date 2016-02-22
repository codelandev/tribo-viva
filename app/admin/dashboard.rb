ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Últimas 10 compras realizadas HOJE" do
          purchases = Purchase.where(status: PurchaseStatus::PAID,
                                     created_at: Date.today.beginning_of_day..Date.today.end_of_day)
                              .last(10)
          table do
            th "Usuário"
            th "Realizado em"
            th "No valor de"
            purchases.each do |purchase|
              tr do
                td link_to(purchase.user.name, admin_purchase_path(purchase))
                td l purchase.created_at
                td number_to_currency purchase.total
              end
            end
          end

          table do
            th "Total"
            tr do
              td number_to_currency purchases.sum(&:total)
            end
          end
        end
      end

      column do
        panel "Churn rate do mês de #{l Date.today, format: '%B'}" do
          month           = Date.today.beginning_of_month..Date.today.end_of_month
          query           = User.joins(:purchases).where(purchases: {created_at: month}).group('users.id')
          buyers          = query.having('count(purchases.id) > 0').length
          new_users       = query.having('count(purchases.id) = 1').length
          recurrent_users = query.having('count(purchases.id) > 1').length

          table do
            th "Total de compradores"
            th "Usuários com 1 compra"
            th "Usuários com 1+ compras"
            th "Chorn Rate este mês"
            tr do
              td buyers
              td new_users
              td recurrent_users
              td number_to_percentage(recurrent_users*100.0/buyers, precision: 2)
            end
          end
        end
      end

    end
  end
end
