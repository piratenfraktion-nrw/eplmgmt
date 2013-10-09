class ApplicationController < ActionController::Base
  before_filter :load_params, only: [:create]
  helper_method :sort_column, :sort_direction
  
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
    begin
      redirect_to :back, :alert => exception.message
    rescue ActionController::RedirectBackError
      redirect_to '/', :alert => exception.message
    end
  end

  private
  def current_ability
    group = Group.find(params[:group_id]) if params[:group_id].present? rescue nil
    pad = Pad.find(params[:id]) if params[:id].present? rescue nil
    group ||= Group.find(params[:id]) unless params[:group_id].present? rescue nil
    group ||= Group.find_by(name: params[:group]) if params[:group].present? rescue nil
    group ||= Group.find_by(name: 'ungrouped') if params[:pad].present? rescue nil
    pad = group.pads.find_by(name: params[:pad]) if !group.nil? && !params[:id].present? rescue nil

    @current_ability ||= Ability.new(current_user, group, pad)
  end
=begin
  def current_ability
    pad = nil
    group = nil
    if params[:id].present?
      pad = Pad.find(params[:id]) rescue nil
      pad = Pad.find_by_name(params[:id]) if pad.nil?
      pad = Pad.find_by(readonly_id: params[:id]) if pad.nil? && current_user.nil?
      group = pad.group unless pad.nil?
      group = Group.find(params[:id]) if pad.nil?
    elsif params[:pad].present? && params[:group].present?
      group = Group.find_by(name: params[:group])
      pad = group.pads.find_by(name: params[:pad]) rescue nil
    elsif params[:group_id].present?
      group = Group.find(params[:group_id])
    end

    @current_ability ||= Ability.new(current_user, group, pad)
  end
=end

  def sort_direction  
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'desc'  
  end

  def sort_column
    sort_by = 'updated_at'
    cols = Pad.column_names
    User.column_names.each { |g| cols << 'users.'+g }
    sort = params[:sort].gsub('-','.') if params[:sort].present?
    cols.include?(sort) ? sort : sort_by
  end
end
