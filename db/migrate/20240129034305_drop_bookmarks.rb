class DropBookmarks < ActiveRecord::Migration[7.0]
  def change
    drop_table :bookmarks
  end
end
