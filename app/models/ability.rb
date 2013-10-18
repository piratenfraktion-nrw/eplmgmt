class Ability
  include CanCan::Ability

  def initialize(user, group=nil, pad=nil)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all
      can :sign_up, :user
    elsif !user.id.nil?
      can :groups, User
      can :create, Group
      unless group.nil?
        if group.name == I18n.t(ENV['UNGROUPED_NAME']) || group.users.include?(user) || group.managers.include?(user) || group.creator == user
          can :read, Group
          can :create, Pad
          can :create_pad, Group
          if group.managers.include?(user) || group.creator == user
            can :update, Group
            can :destroy, Group
          end
        end
      end
    end
    unless pad.nil?
      if pad.creator == user || pad.group.managers.include?(user) || pad.group.creator == user
        can :update, Pad
        can :destroy, Pad
      end
      if user.id.nil?
        if pad.is_public || pad.is_public_readonly
          can :read, Pad
        end
      else
        if pad.is_public || pad.is_public_readonly || pad.creator == user || pad.group.name == I18n.t(ENV['UNGROUPED_NAME']) || pad.group.users.include?(user) || pad.group.managers.include?(user) || pad.group.creator == user
          can :read, Pad
        end
      end
    end
  end
end
