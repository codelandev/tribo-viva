class RenameProductsDescriptionToDescriptionOnOffers < ActiveRecord::Migration
  def change
    rename_column :offers, :products_description, :description
  end
end
