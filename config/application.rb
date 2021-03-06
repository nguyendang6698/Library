require_relative 'boot'

require File.expand_path('../boot', __FILE__)
require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module LibraryVLC
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
    # config.assets.enabled = true


  end
end
