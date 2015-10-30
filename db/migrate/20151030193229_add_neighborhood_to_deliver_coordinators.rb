class AddNeighborhoodToDeliverCoordinators < ActiveRecord::Migration
  def change
    add_column :deliver_coordinators, :neighborhood, :string, null: false, default: ''
  end
end
