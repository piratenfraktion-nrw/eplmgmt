class AddEditedAtToPads < ActiveRecord::Migration
  def change
    add_column :pads, :edited_at, :datetime
  end
end
