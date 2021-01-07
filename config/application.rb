require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Quiencobralaobra
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    #config.i18n.default_locale = :es

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Workaround to carrierwave doing "require 'fog'""
    # This let's us get ./lib in the load path, where our own fake
    # fog.rb is loaded for carrierwave, but we've already loaded
    # fog-aws (require 'fog/aws'), which is all we need anyway.
    # See https://gist.github.com/darrenboyd/feb2bc38f46a88e44b8d
    config.before_configuration do
      require 'carrierwave'
    end
  end
end
