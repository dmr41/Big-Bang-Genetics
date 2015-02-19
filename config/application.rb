require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'csv'

require 'wikipedia'

require 'json'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BigBangGenetics
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << Rails.root.join('vendor', 'assets', 'd3')
  end
end
