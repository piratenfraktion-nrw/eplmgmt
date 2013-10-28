require 'media_wiki'
require 'Mediawiki'
Mediawiki.setup do |config|
  config.api_url = ENV['MW_URL']+ENV['MW_API_PATH']
  config.username = ENV['MW_USERNAME']
  config.password = ENV['MW_PASSWORD']
  config.domain = ENV['MW_DOMAIN']
end
