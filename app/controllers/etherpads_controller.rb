class EtherpadsController < ApplicationController
  # /etherpad
  def index
    # Your users are probably members of some kind of groups.
    # These groups can be mapped to EtherpadLite Groups. List all the user's groups.
    @app_groups = current_user.groups
  end

  # /etherpad/groups/:id
  def group
    ether = EtherpadLite.connect(9001, File.new('/home/vileda/Projects/pfnrw/etherpad-lite/APIKEY.txt'))
    @app_group = YourAppGroup.find(params[:id])
    # Map your app's group to an EtherpadLite Group, and list all its pads
    group = ether.group("my_app_group_#{@app_group.id}")
    @pads = group.pads
  end

  # /etherpad/pads/:ep_group_id/:ep_pad_name
  def pad
    ether = EtherpadLite.connect(9001, File.new('/srv/www/etherpad-lite/APIKEY.txt'))
    # Get the EtherpadLite Group and Pad by id
    @group = ether.get_group(params[:ep_group_id])
    @pad = @group.pad(params[:ep_pad_name])
    # Map the user to an EtherpadLite Author
    author = ether.author("my_app_user_#{current_user.id}", :name => current_user.name)
    # Get or create an hour-long session for this Author in this Group
    sess = session[:ep_sessions][@group.id] ? ether.get_session(session[:ep_sessions][@group.id]) : @group.create_session(author, 60)
    if sess.expired?
      sess.delete
      sess = @group.create_session(author, 60)
    end
    session[:ep_sessions][@group.id] = sess.id
    # Set the EtherpadLite session cookie. This will automatically be picked up by the jQuery plugin's iframe.
    cookies[:sessionID] = {:value => sess.id, :domain => ".yourdomain.com"}
  end
end
