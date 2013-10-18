class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  #validates :user_id, uniqueness: {scope: :group_id}

  has_paper_trail
end
