class Pad < ActiveRecord::Base
  include Etherpad
  before_validation :etherpad, on: [:create]
  before_update :update_ep
  before_destroy :delete_pad
  belongs_to :group, touch: true
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"

  validates_presence_of :pad_id, :on => :create, :message => "can't be blank"
  validates_presence_of :group_id, :on => :create, :message => "can't be blank"

  def etherpad
    if self.group.nil?
      @ep_group = ether.group('ungrouped')
      group = Group.find_by_group_id(@ep_group.id)
      if group.nil?
        group = Group.new
        group.group_id = @ep_group.id
        group.name = 'ungrouped'
        group.creator_id = self.creator_id
        group.save!
      end
      self.group = group
    end
    ep_pad = self.group.ep_group.pad(self.name)
    self.pad_id = ep_pad.id
    self.edited_at = DateTime.strptime(ep_pad.last_edited.to_s, '%Q')
    self.readonly_id = ep_pad.read_only_id
    update_ep
    true
  end

  def update_ep
    if self.name != self.name_was
      text_was = self.ep_pad.text
      self.ep_pad.delete
      pad = self.group.ep_group.pad(self.name, text: text_was)
      self.pad_id = pad.id
    end
    if self.is_public != self.is_public_was ||
      self.password != self.password_was
      pad = ep_pad
      pad.password = self.password
    end
  end

  def ep_pad
    group.ep_group.get_pad(self.pad_id)
  end

  def delete_pad
    self.ep_pad.delete
  end

  def delete_ep_pad
    false
  end

  def delete_ep_pad=(del_pad)
    del_pad
  end

  def options
    return 'read' if self.is_public_readonly
    return 'write' if self.is_public && ep_pad.public?
    return 'closed'
  end

  def options=(opt)
    self.is_public = (opt == 'write')
    self.is_public_readonly = (opt == 'read')
    ep_pad.public = (self.is_public || self.is_public_readonly)
  end
end
