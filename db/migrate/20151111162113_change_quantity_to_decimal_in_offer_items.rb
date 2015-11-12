class ChangeQuantityToDecimalInOfferItems < ActiveRecord::Migration
  def self.up
    change_column :offer_items, :quantity, :decimal, precision: 10, scale: 2
  end

  def self.down
    change_column :offer_items, :quantity, :integer
  end
end
