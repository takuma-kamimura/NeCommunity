class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, foreign_key: true, null: false
      t.references :cat, foreign_key: true # cat_idがなくても良い
      t.string :title, null: false
      t.text :body, null: false
      t.string :photo

      t.timestamps
    end
  end
end
