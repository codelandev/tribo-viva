class AddReceiptToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :receipt, :string, null: false, default: ''
  end
end
