class AddCoverImageToProducer < ActiveRecord::Migration
  def change
    add_column :producers, :cover_image, :string
  end
end
