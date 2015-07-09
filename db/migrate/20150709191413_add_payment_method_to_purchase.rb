class AddPaymentMethodToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :payment_method, :string
  end
end
