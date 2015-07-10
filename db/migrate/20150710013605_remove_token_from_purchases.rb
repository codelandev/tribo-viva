class RemoveTokenFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :token
  end
end
