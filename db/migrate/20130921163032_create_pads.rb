class CreatePads < ActiveRecord::Migration
  def change
    create_table :pads do |t|
      t.string :pad_id
      t.references :group, index: true
      t.string :name
      t.string :password
      t.integer :creator_id

      t.timestamps
    end
    add_index :pads, :pad_id, unique: true
  end
end
