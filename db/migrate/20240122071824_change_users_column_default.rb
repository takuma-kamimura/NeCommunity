class ChangeUsersColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :self_introduction, nil
  end
end
