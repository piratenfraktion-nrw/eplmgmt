module Etherpad
  mattr_accessor :api_url
  mattr_accessor :api_version
  mattr_accessor :api_key

  def ep_api
    EtherpadLite.client(@@api_url, @@api_key, @@api_version)
  end

  def ether
    EtherpadLite.connect(@@api_url, @@api_key, @@api_version)
  end

  def self.setup
    yield self
  end

end
