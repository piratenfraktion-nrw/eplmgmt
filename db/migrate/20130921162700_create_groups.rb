class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :group_id
      t.string :name
      t.integer :creator_id

      t.timestamps
    end
    add_index :groups, :group_id, unique: true
  end
end
