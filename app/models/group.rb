#encoding: UTF-8

class Group < ActiveRecord::Base
  include Etherpad
  before_create :etherpad
  before_update :update_users
  has_many :pads
  has_many :group_users
  has_many :users, :through => :group_users
  has_many :managers, :through => :group_users, :source => :user, :conditions => {manager: true}
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_format_of :name, :with => /[\.[:digit:][:alpha:]%_-]+/, message: I18n.t('is_invalid')

  def etherpad
    ep_group = ether.group(self.name)
    self.group_id = ep_group.id
    ep_group.create_session(ether.author(self.creator.name), 480) if self.creator
    update_users
  end

  def update_users
    self.users.each do |user|
      ep_group.create_session(ether.author(user.name), 480)
    end
  end

  def ep_group
    ether.get_group(self.group_id)
  end
end
