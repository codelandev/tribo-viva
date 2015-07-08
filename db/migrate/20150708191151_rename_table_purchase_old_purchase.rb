class RenameTablePurchaseOldPurchase < ActiveRecord::Migration
  def change
    rename_table :purchases, :old_purchases
  end
end
