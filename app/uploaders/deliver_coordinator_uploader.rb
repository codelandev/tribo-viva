class DeliverCoordinatorUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mini_thumb do
    process resize_to_fit: [55, 55]
  end

  version :admin_thumb do
    process resize_to_fit: [100, 100]
  end
end
