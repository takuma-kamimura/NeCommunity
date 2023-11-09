class CreateCats < ActiveRecord::Migration[7.0]
  def change
    create_table :cats do |t|
      t.references :user, foreign_key: true, null: false
      t.references :cat_breed, foreign_key: true, null: false
      t.string :name, null: false # 名前
      t.datetime :birthday # 誕生日
      t.integer :gender, null: false # 性別
      t.string :avatar # プロフィール画像
      t.text :self_introduction # ユーザーの猫の紹介欄

      t.timestamps
    end
  end
end
