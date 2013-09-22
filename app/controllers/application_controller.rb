class ApplicationController < ActionController::Base
  before_filter :load_params, only: [:create]
  
  def load_params
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :alert => exception.message
  end

  def current_ability
    group = Group.find(params[:id]) rescue nil
    group = Group.find(params[:group_id]) if params[:group_id].present? rescue nil
    pad = Pad.find(params[:id]) rescue nil
    pad = Pad.find_by_group_id_and_id(group.id, params[:id]) if params[:group_id].present? rescue nil
    pad = Group.find_by_name('ungrouped').pads.find_by_name(params[:id]) if @pad.nil? rescue nil
    @current_ability ||= Ability.new(current_user, group, pad)
  end
end
