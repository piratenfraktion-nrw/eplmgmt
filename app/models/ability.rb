class Ability
  include CanCan::Ability

  def initialize(user, group=nil, pad=nil)
    user ||= User.new # guest user (not logged in)
    group ||= Group.new
    pad ||= Pad.new

    if pad.is_public || pad.is_public_readonly || !user.id.nil?
      can :read, Pad
    end
    
    can :read, Pad, :is_public => true
    
    if user.has_role? :admin
      can :manage, :all
      can :sign_up, :user
    elsif user.id
      can :read, Group
      can :create, Group
    end

    if group.creator == user || group.managers.include?(user)
      can :update, Group
      can :destroy, Group
    end
    
    if group.users.include?(user) || group.managers.include?(user) || group.name == 'ungrouped'
      can :create, Pad
    end

    if pad.creator == user || group.managers.include?(user)
      can :update, Pad
      can :destroy, Pad
    end
  end
end
