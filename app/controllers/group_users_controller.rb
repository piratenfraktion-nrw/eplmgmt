class GroupUsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_action :set_group_user, only: [:show, :edit, :update, :destroy]

  # GET /group_users
  # GET /group_users.json
  def index
    @group_users = GroupUser.all
  end

  # GET /group_users/1
  # GET /group_users/1.json
  def show
  end

  # GET /group_users/new
  def new
    @group_user = GroupUser.new
  end

  # GET /group_users/1/edit
  def edit
  end

  # POST /group_users
  # POST /group_users.json
  def create
    @group_user = GroupUser.new(group_user_params)

    respond_to do |format|
      if @group_user.save
        format.html { redirect_to @group_user, notice: 'Group user was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group_user }
      else
        format.html { render action: 'new' }
        format.json { render json: @group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_users/1
  # PATCH/PUT /group_users/1.json
  def update
    respond_to do |format|
      if @group_user.update(group_user_params)
        format.html { redirect_to @group_user, notice: 'Group user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_users/1
  # DELETE /group_users/1.json
  def destroy
    @group_user.destroy
    respond_to do |format|
      format.html { redirect_to group_users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_user
      @group_user = GroupUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_user_params
      params.require(:group_user).permit(:group_id, :user_id, :manager)
    end
end
