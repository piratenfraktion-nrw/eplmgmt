class AddWasPublicWriteableToPads < ActiveRecord::Migration
  def change
    add_column :pads, :was_public_writeable, :boolean
  end
end
