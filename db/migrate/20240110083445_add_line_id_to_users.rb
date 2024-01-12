class AddLineIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :line_id, :string
  end
end
