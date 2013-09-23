class Ability
  include CanCan::Ability

  def initialize(user, group=nil, pad=nil)
    user ||= User.new # guest user (not logged in)
    group ||= Group.new
    pad ||= Pad.new

    can :read, Pad
    
    if user.has_role? :admin
      can :manage, :all
      can :sign_up, :user
    elsif user.id
      can :read, Group
      can :create, Group
    end

    if group.creator == user
      can :update, Group
      can :destroy, Group
    end
    
    if group.users.include?(user) || group.name == 'ungrouped'
      can :create, Pad
    end

    if pad.creator == user
      can :update, Pad
      can :destroy, Pad
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
