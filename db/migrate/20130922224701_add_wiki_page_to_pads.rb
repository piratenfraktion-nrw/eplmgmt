class AddWikiPageToPads < ActiveRecord::Migration
  def change
    add_column :pads, :wiki_page, :string
  end
end
