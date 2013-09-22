class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  before_create :set_manager

  def set_manager
    if self.user == self.group.creator
      self.manager = true
    end
  end
end
