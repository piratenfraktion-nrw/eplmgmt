class User < ActiveRecord::Base
  before_validation :get_ldap_email

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def get_ldap_email
    self.email = Devise::LDAP::Adapter.get_ldap_param(self.name,"mail")[0]
  end
end
