class PadsController < ApplicationController
  include Etherpad
  include Mediawiki
  layout 'pad', only: [:show]
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_pad, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /pads
  # GET /pads.json
  def index
    if params[:group_id].present?
    @group = Group.find(params[:group_id])
    else
    @group = Group.find_or_create_by(name: 'ungrouped')
    end

    if current_user.nil?
      @group = Group.find_by(name: 'ungrouped')
    end

    @pads = Pad.joins(:group, :creator).order(sort_column + ' ' + sort_direction)
    @pads = @pads.where("pads.group_id = ?", @group.id)
    @pads = @pads.where(is_public: true) if current_user.nil?
  end

  # GET /p/1
  # GET /p/1.json
  def show
    cookies[:sessionID] = nil

    if user_signed_in?
      @author = ether.author(current_user.name, name: current_user.name)
      @author.sessions.each do |sess|
        if sess.expired? || !@pad.group.users.include?(current_user)
          sess.delete
        end
      end
      if @pad.group.users.include?(current_user) || @pad.group.name == 'ungrouped'
        sess = @pad.group.ep_group.create_session(@author, 480)
        cookies[:sessionID] = {:value => sess.id}
      end
    end

    @has_drawer = user_signed_in? && @pad.creator == current_user
    @is_public_readonly = !user_signed_in? && @pad.is_public_readonly
  end

  # GET /pads/new
  def new
    @pad = Pad.new
    @group = Group.find(params[:group_id])
  end

  # GET /pads/1/edit
  def edit
  end

  # POST /pads
  # POST /pads.json
  def create
    @pad = Pad.new(pad_params)
    @group = Group.find(params[:group_id])

    @pad.creator_id = current_user.id
    @pad.group = @group

    respond_to do |format|
      if @pad.save
        format.html {
          pad_url = '/p/'+@group.name+'/'+@pad.name
          pad_url = '/p/'+@pad.name if @group.name == 'ungrouped'
          redirect_to pad_url, notice: 'Pad was successfully created.'
        }
        format.json { render action: 'show', status: :created, location: @pad }
      else
        format.html { render action: 'new', error: 'Error' }
        format.json { render json: @pad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pads/1
  # PATCH/PUT /pads/1.json
  def update
    if pad_params[:wiki_page].present?
      mw.edit(pad_params[:wiki_page], @pad.ep_pad.text, :summary => 'via Eplmgmt by '+current_user.name)
    end

    respond_to do |format|
      if @pad.update(pad_params)
        format.html { 
          if (params[:pad][:delete_ep_pad] == 'true') && pad_params[:wiki_page].present?
            @pad.destroy
            redirect_to ENV['MW_URL']+'/wiki/'+@pad.wiki_page, notice: 'Pad was successfully updated'
          elsif (params[:pad][:delete_ep_pad] == 'true')
            @pad.destroy
            if @pad.group.name == 'ungrouped'
              redirect_to '/pads'
            else
              redirect_to group_path(@pad.group)
            end
          elsif pad_params[:wiki_page].present?
            redirect_to ENV['MW_URL']+'/wiki/'+@pad.wiki_page, notice: 'Pad was successfully updated'
          else
            redirect_to edit_pad_path(@pad), notice: 'Pad was successfully updated'
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pads/1
  # DELETE /pads/1.json
  def destroy
    @pad.destroy
    respond_to do |format|
      format.html { redirect_to pads_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pad
      if params[:id].present?
        @pad = Pad.find(params[:id]) rescue nil
        @pad = Pad.find_by_name(params[:id]) if @pad.nil?
        @pad = Pad.find_or_create_by(name: params[:id],
                                     creator_id: current_user.id) if @pad.nil? && !current_user.nil?
        @pad = Pad.find_by(readonly_id: params[:id]) if @pad.nil? && current_user.nil?
      elsif params[:pad].present? && params[:group].present?
        group = Group.find_by(name: params[:group])
        @pad = group.pads.find_by(name: params[:pad]) rescue nil
        @pad = group.pads.find_or_create_by(name: params[:pad],
                                            creator_id: current_user.id) if @pad.nil?
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pad_params
      params.require(:pad).permit(:name, :password, :options, :wiki_page)
    end
end
