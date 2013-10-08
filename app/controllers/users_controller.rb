class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :index, @user, :message => t('not_admin')
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def update
    authorize! :update, @user, :message => t('not_admin')
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => t('user_updated')
    else
      redirect_to users_path, :alert => t('user_update_fail')
    end
  end
    
  def destroy
    authorize! :destroy, @user, :message => t('not_admin')
    user = User.find(params[:id])
    if user == current_user
      redirect_to users_path, :notice => t('cant_delete_yourself')
    else
      user.destroy
      redirect_to users_path, :notice => t('user_deleted')
    end
  end
end
