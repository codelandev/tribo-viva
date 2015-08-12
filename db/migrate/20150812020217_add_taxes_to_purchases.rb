class AddTaxesToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :taxes, :decimal, null: false, default: 0.00, scale: 2, precision: 10
  end
end
