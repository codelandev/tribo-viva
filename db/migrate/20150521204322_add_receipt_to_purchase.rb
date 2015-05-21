class AddReceiptToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :receipt, :string
  end
end
