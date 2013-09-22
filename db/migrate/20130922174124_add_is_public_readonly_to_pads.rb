class AddIsPublicReadonlyToPads < ActiveRecord::Migration
  def change
    add_column :pads, :is_public_readonly, :boolean
  end
end
