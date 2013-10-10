class User < ActiveRecord::Base
  before_validation :get_ldap_email
  before_validation :get_ldap_nickname
  before_update :get_ldap_nickname
  has_many :pads, :class_name => 'Pad', :foreign_key => 'creator_id'
  validates_presence_of :nickname

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def get_ldap_email
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.name, 'mail')[0]
  end

  def get_ldap_nickname
    nick = Devise::LDAP::Adapter.get_ldap_param(self.name, 'nick')[0] rescue ''
    nick = 'anonymous' if nick.length < 2
    self.nickname = nick
  end
end
