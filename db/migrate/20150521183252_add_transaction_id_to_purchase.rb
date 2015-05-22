class AddTransactionIdToPurchase < ActiveRecord::Migration
  def change
    add_column :purchases, :transaction_id, :string, null: false, default: ''
  end
end
