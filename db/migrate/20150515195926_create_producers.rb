class CreateProducers < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.text :description,    null: false, default: ''
      t.string :name,         null: false, default: ''
      t.string :logo,         null: false, default: ''
      t.string :phone,        null: false, default: ''
      t.string :email,        null: false, default: ''
      t.string :address,      null: false, default: ''
      t.string :contact_name, null: false, default: ''

      t.timestamps null: false
    end
  end
end
