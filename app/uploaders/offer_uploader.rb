class OfferUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :home_thumb do
    process resize_to_fit: [240, 200]
  end

  version :show_cover do
    process resize_to_fit: [737, 460]
  end

  version :admin_thumb do
    process resize_to_fill: [160, 100]
  end
end
