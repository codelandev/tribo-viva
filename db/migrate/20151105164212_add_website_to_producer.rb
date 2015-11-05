class AddWebsiteToProducer < ActiveRecord::Migration
  def change
    add_column :producers, :website, :string
  end
end
