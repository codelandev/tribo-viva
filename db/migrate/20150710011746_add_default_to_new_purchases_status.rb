class AddDefaultToNewPurchasesStatus < ActiveRecord::Migration
  def change
    change_column :purchases, :status, :string, null: false, default: PurchaseStatus::PENDING
  end
end
