class HomeController < ApplicationController
  def index
    if user_signed_in?
      @group = Group.find_or_create_by(name: 'ungrouped')
      @pad = @group.pads.build
      @pads = Pad.joins('LEFT JOIN users ON users.id = pads.creator_id')
      @pads = @pads.order(sort_column + ' ' + sort_direction).limit(10)
    else
      redirect_to named_pads_path, notice: t('devise.failure.unauthenticated')
    end
  end

  # GET /p
  # GET /p.json
  def pads
    @pads = Pad.joins('LEFT JOIN users ON users.id = pads.creator_id')
    @pads = @pads.where("is_public = 't' or is_public_readonly = 't'") unless user_signed_in?
    @pads = @pads.order(sort_column + ' ' + sort_direction)
  end
end
