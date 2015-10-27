class AddUserTypeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :user_type, :string
    remove_foreign_key :purchases, :user
  end

  def migrate(direction = :up)
    super
    if direction == :up
      Purchase.update_all(user_type: 'User')
    end
  end
end
