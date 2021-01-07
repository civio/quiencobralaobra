CarrierWave.configure do |config|
  config.fog_credentials = {
    # Configuration for Amazon S3 should be made available through an Environment variable.
    # For local installations, export the env variable through the shell OR
    # if using Passenger, set an Apache environment variable.
    :provider               => 'AWS',                           # required
    :aws_access_key_id      => ENV['S3_KEY'],                   # required
    :aws_secret_access_key  => ENV['S3_SECRET'],                # required
    :region                 => ENV['S3_REGION']                 # optional, defaults to 'us-east-1'
    # :host                   => 's3.example.com',              # optional, defaults to nil
    # :endpoint               => 'https://s3.example.com:8080'  # optional, defaults to nil
  }

  config.fog_directory  = ENV['S3_BUCKET_NAME']                    # required
  # config.fog_public     = false                                  # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}   # optional, defaults to {}

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.root = "#{Rails.root}/tmp"
    config.enable_processing = false
  # Disable AWS S3 for now, maybe for ever. See civio/infra-management#146
  # elsif Rails.env.production? or ENV['FORCE_S3_IN_DEV']=='true'
  #   config.storage = :fog
  else
    config.storage = :file
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
