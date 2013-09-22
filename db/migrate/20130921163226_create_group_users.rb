class CreateGroupUsers < ActiveRecord::Migration
  def change
    create_table :group_users do |t|
      t.references :group, index: true
      t.references :user, index: true
      t.boolean :manager

      t.timestamps
    end
  end
end
