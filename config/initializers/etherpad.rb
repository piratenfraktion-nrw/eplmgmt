require 'Etherpad'
Etherpad.setup do |config|
  config.api_url = ENV['EPL_API_URL']
  config.api_version = ENV['EPL_API_VERSION']
  config.api_key = ENV['EPL_API_KEY']
end
