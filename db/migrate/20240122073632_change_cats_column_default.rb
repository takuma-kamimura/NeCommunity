class ChangeCatsColumnDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :cats, :self_introduction, nil
  end
end
