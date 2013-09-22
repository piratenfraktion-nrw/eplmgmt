class AddReadonlyIdToPads < ActiveRecord::Migration
  def change
    add_column :pads, :readonly_id, :string
  end
end
