class GroupsController < ApplicationController
  include Etherpad
  before_filter :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :group, except: [:index]

  # GET /groups
  # GET /groups.json
  def index
    authorize! :groups, current_user
    @groups = Group
                .joins('LEFT JOIN users ON users.id = groups.creator_id')
                .where('groups.name != ?', ENV['UNGROUPED_NAME'])
                .order(sort_column + ' ' + sort_direction)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @pads = @group.pads
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    @group.creator_id = current_user.id

    respond_to do |format|
      if @group.save
        #hack for https://github.com/rails/rails/issues/12464
        params[:id] = @group.id
        set_group
        @group.update(group_params)

        format.html { redirect_to @group, notice: t('group_created') }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: t('group_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      uid = current_user.id.to_s
      p = params.require(:group).permit(:name, {user_ids: [], manager_ids: []})
      p[:manager_ids] = [] unless p[:manager_ids].present?
      p[:manager_ids] << uid unless p[:manager_ids].include?(uid.to_s)
      p
    end
end
