class AddIuguCustomerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :iugu_customer, :string
  end
end
