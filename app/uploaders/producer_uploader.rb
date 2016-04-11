class ProducerUploader < ImageUploader
  version :thumb do
    process resize_to_fit: [240, 200]
  end

  version :offer_show_cover do
    process resize_to_fit: [737, 200]
  end

  version :admin_thumb do
    process resize_to_fill: [120, 100]
  end

  version :admin_cover do
    process resize_to_fill: [564, 200]
  end
end
