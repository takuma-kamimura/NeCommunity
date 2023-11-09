class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name # ユーザーの名前
      t.string :email, null: false, index: { unique: true } # ユーザーの登録メールアドレス。重複をNG
      t.string :crypted_password
      t.string :salt
      t.string :avatar # ユーザーのプロフィール画像。
      t.text :self_introduction # ユーザーの自己紹介欄
      t.integer :role, null: false, default: 0 # 一般ユーザー or 管理者権限

      t.timestamps                null: false
    end
  end
end
