class CreateHealthRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :health_records do |t|
      t.references :cat, foreign_key: true, null: false
      t.float :weight, default: 0
      t.text :note, default: 'まだ記録していないよ'

      t.timestamps
    end
  end
end
