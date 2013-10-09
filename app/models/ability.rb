class Ability
  include CanCan::Ability

  def initialize(user, group=nil, pad=nil)
    user ||= User.new # guest user (not logged in)
    group ||= Group.new
    pad ||= Pad.new

    if user.has_role? :admin
      can :manage, :all
      can :sign_up, :user
    elsif !user.id.nil?
      can :read, Group
      can :create, Group
    elsif user.id.nil?
      can :read, Pad, :is_public => true
      if pad.is_public || pad.is_public_readonly
        can :read, Pad
      end
    end

    if group.creator == user || group.managers.to_a.include?(user)
      can :manage, Group
    end

    if group.creator == user || group.managers.to_a.include?(user) || group.users.to_a.include?(user)
      can :create, Pad
      can :read, Pad
    end
    
    if group.name == 'ungrouped' && !user.nil?
      can :read, Pad
    end

    if group.creator == user || group.managers.to_a.include?(user)
      can :manage, Pad
    end
  end
end
