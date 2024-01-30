class DrophealthRecords < ActiveRecord::Migration[7.0]
  def change
    drop_table :health_records
  end
end
