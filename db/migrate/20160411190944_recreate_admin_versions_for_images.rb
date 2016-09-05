class RecreateAdminVersionsForImages < ActiveRecord::Migration
  def change
    DeliverCoordinator.find_each do |resource|
      resource.avatar.recreate_versions! if resource.avatar?
      resource.save
    end
    Offer.find_each do |resource|
      resource.image.recreate_versions! if resource.image?
      resource.save
    end
    Producer.find_each do |resource|
      resource.logo.recreate_versions! if resource.logo?
      resource.cover_image.recreate_versions! if resource.cover_image?
      resource.save
    end
  end
end
