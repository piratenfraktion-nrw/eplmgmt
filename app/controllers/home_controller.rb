class HomeController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check

  def index
    @group = Group.find_or_create_by(name: 'ungrouped')
    @pad = Pad.new
  end
end
