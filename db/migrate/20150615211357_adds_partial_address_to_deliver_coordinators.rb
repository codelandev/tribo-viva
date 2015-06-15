class AddsPartialAddressToDeliverCoordinators < ActiveRecord::Migration
  def change
    add_column :deliver_coordinators, :partial_address, :string, null: false, default: ''
  end
end
