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
  elsif Rails.env.test? or Rails.env.cucumber?
    config.enable_processing = false
  else
    config.storage = :file
  end
end
