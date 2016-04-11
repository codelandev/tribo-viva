class DeliverCoordinatorUploader < BaseUploader
  version :mini_thumb do
    process resize_to_fit: [55, 55]
  end

  version :admin_thumb do
    process resize_to_fit: [100, 100]
  end
end
