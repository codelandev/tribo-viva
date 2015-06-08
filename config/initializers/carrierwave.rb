CarrierWave.configure do |config|
  if Rails.env.production? || Rails.env.staging?
    config.storage = :fog
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region:                Rails.application.secrets.aws_region,
    }
    config.fog_directory = Rails.application.secrets.aws_bucket_name
  else
    config.storage = :file
    config.enable_processing = false if Rails.env.test? || Rails.env.cucumber?
  end
end
