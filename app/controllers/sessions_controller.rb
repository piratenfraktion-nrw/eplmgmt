class SessionsController < Devise::SessionsController
  after_filter :set_ep_session, :only => :new
  def create
    cookies[:sessionID] = 'fresh'
    super
  end
  def destroy
    cookies[:sessionID] = 'cleared'
    super
  end

  private

  def set_ep_session
    session[:ep_sessions] = {}
  end
end
