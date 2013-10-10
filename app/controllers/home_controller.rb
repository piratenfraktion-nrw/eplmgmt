class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:pads]

  def index
    @group = Group.find_or_create_by(name: 'ungrouped')
    @pad = @group.pads.build
    @pads = Pad.joins('LEFT JOIN users ON users.id = pads.creator_id')
    @pads = @pads.order(sort_column + ' ' + sort_direction).limit(10)
  end

  # GET /p
  # GET /p.json
  def pads
    @pads = Pad.joins('LEFT JOIN users ON users.id = pads.creator_id')
    @pads = @pads.where("is_public = 't' or is_public_readonly = 't'") unless user_signed_in?
    @pads = @pads.order(sort_column + ' ' + sort_direction)
  end
end
