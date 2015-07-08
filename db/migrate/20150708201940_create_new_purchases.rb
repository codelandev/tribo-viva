class CreateNewPurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.references :user, index: true, foreign_key: true
      t.string :token
      t.string :status
      t.decimal :total, null: false, default: 0.0, scale: 2, precision: 10

      t.timestamps null: false
    end

    add_index :purchases, :token, unique: true
  end
end
