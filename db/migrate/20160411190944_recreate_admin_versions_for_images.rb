class RecreateAdminVersionsForImages < ActiveRecord::Migration
  def change
    DeliverCoordinator.find_each do |resource|
      resource.avatar.recreate_versions!
      resource.save
    end
    Offer.find_each do |resource|
      resource.image.recreate_versions!
      resource.save
    end
    Producer.find_each do |resource|
      resource.logo.recreate_versions!
      resource.cover_image.recreate_versions!
      resource.save
    end
  end
end
