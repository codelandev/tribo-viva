class PurchaseUploader < CarrierWave::Uploader::Base
  def store_dir
    "uploads/purchase/#{mounted_as}/#{model.id}"
  end
end
