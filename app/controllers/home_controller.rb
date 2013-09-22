class HomeController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check

  def index
    @group = Group.find_by_name('ungrouped')
    @pad = Pad.new
  end
end
