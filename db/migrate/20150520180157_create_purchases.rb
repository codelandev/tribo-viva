class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :user, index: true, foreign_key: true
      t.references :offer, index: true, foreign_key: true
      t.integer :amount, null: false, default: 0
      t.string :status, null: false, default: 'pending'

      t.timestamps null: false
    end
  end
end
