class HomeController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check

  def index
    @group = Group.find_or_create_by(name: 'ungrouped')
    @pad = Pad.new

    @group = Group.find_or_create_by(name: 'ungrouped')
    @pads = @group.pads.joins(:group)
    @pads = @pads.where("pads.group_id = ?", @group.id)
    @pads = @pads.where(is_public: true) if current_user.nil?
    @pads = @pads.order(sort_column + ' ' + sort_direction).limit(10)
  end
end
