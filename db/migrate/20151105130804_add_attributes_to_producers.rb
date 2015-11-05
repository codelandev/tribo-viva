class AddAttributesToProducers < ActiveRecord::Migration
  def change
    add_column :producers, :certification, :string
    add_column :producers, :video_url, :string
  end
end
