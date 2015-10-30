class CreateOfferItems < ActiveRecord::Migration
  def change
    create_table :offer_items do |t|
      t.references :offer, index: true, foreign_key: true
      t.string :name, nul: false, default: ''
      t.string :unit, null: false, default: 1
      t.integer :quantity, null: false, default: 1
      t.decimal :unit_price, null: false, default: 0.0, scale: 2, precision: 10

      t.timestamps null: false
    end
  end
end
