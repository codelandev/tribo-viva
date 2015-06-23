class AddPhoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string, null: false, default: ''
  end
end
