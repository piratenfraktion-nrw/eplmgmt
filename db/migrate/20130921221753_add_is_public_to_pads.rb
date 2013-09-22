class AddIsPublicToPads < ActiveRecord::Migration
  def change
    add_column :pads, :is_public, :boolean
  end
end
