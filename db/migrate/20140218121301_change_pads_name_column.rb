class ChangePadsNameColumn < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :pads do |t|
        dir.up   { t.change :name, :string, :limit => 50 }
        dir.down { t.change :name, :string, :limit => nil }
      end
    end
  end
end
