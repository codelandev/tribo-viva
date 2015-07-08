class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :offer, index: true, foreign_key: true
      t.references :purchase, index: true, foreign_key: true
      t.integer :quantity
      t.decimal :offer_value

      t.timestamps null: false
    end
  end
end
