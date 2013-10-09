class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:pads]

  def index
    @group = Group.find_or_create_by(name: 'ungrouped')
    @pad = @group.pads.build
    fetch_pads(@group)
  end

  # GET /p
  # GET /p.json
  def pads
    if user_signed_in? && params[:group_id].present?
      @group = Group.find(params[:group_id])
    else
      @group = Group.find_or_create_by(name: 'ungrouped')
    end
    fetch_pads(@group)
  end


  def fetch_pads(group)
    @pads = group.pads.joins('LEFT JOIN users ON users.id = pads.creator_id')
    @pads = @pads.where("is_public = 't' or is_public_readonly = 't'") if current_user.nil?
    @pads = @pads.order(sort_column + ' ' + sort_direction)
  end
end
