module Mediawiki
  mattr_accessor :api_url
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :domain

  def mw
    mw = MediaWiki::Gateway.new(@@api_url)
    mw.login(@@username, @@password, @@domain)
    mw
  end

  def self.setup
    yield self
  end
end
