class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.belongs_to :deliver_coordinator, index: true, foreign_key: true
      t.belongs_to :bank_account, index: true, foreign_key: true
      t.belongs_to :producer, index: true, foreign_key: true
      t.text :products_description, null: false, default: ''
      t.string :title, null: false, default: ''
      t.string :image, null: false, default: ''
      t.decimal :value, null: false, default: 0.00, precision: 10, scale: 2
      t.decimal :operational_tax, null: false, default: 0.00, precision: 10, scale: 2
      t.decimal :coordinator_tax, null: false, default: 0.00, precision: 10, scale: 2
      t.integer :stock, null: false, default: 0
      t.datetime :collect_starts_at
      t.datetime :collect_ends_at
      t.datetime :offer_starts_at
      t.datetime :offer_ends_at

      t.timestamps null: false
    end
  end
end
