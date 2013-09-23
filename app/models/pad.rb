class Pad < ActiveRecord::Base
  include Etherpad
  before_validation :etherpad, on: [:create]
  before_update :update_ep
  before_destroy :delete_pad
  belongs_to :group
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
    update_ep
    true
  end

  def update_ep
    text_was = self.ep_pad.text
    if self.name_was != self.name
      ep_pad = self.group.ep_group.pad(self.pad_id)
      ep_pad.delete
    end
    ep_pad = self.group.ep_group.pad(self.name, text: text_was)
    ep_pad.public = self.is_public
    ep_pad.password = self.password
    self.readonly_id = ep_pad.read_only_id
    self.pad_id = ep_pad.id
  end

  def ep_pad
    ether.pad(self.pad_id)
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
end
