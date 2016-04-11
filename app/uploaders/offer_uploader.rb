class OfferUploader < ImageUploader
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
