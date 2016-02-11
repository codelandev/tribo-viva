ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do
      column do
        panel "Últimas 10 compras realizadas HOJE" do
          purchases = Purchase.where(status: PurchaseStatus::PAID,
                                     created_at: 1.month.ago.beginning_of_day..1.month.ago.end_of_day)
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
        panel "Churn rate do mês de #{l 1.month.ago, format: '%B'}" do
          month             = 1.month.ago.beginning_of_month..1.month.ago.end_of_month
          new_users         = User.joins(:purchases).where(purchases: {created_at: month}).group('users.id').having('count(purchases.id) = 1').length
          recurrent_users   = User.joins(:purchases).where(purchases: {created_at: month}).group('users.id').having('count(purchases.id) > 1').length
          total_buyer_users = (new_users+recurrent_users)

          table do
            th "Total de usuários"
            th "Usuários com 1 compra"
            th "Usuários com 1+ compras"
            th "Chorn Rate este mês"
            tr do
              td User.count
              td new_users
              td recurrent_users
              td number_to_percentage(recurrent_users*100/total_buyer_users, precision: 2)
            end
          end
        end
      end

    end
  end
end
