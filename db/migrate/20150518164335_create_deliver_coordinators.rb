class CreateDeliverCoordinators < ActiveRecord::Migration
  def change
    create_table :deliver_coordinators do |t|
      t.string :cpf,     null: false, default: true
      t.string :name,    null: false, default: true
      t.string :phone,   null: false, default: true
      t.string :email,   null: false, default: true
      t.string :avatar,  null: false, default: true
      t.string :address, null: false, default: true

      t.timestamps null: false
    end
  end
end
