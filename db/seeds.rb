# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: '上村 拓磨', email: 'jjd.swt-c.5@docomo.ne.jp', password: "test",password_confirmation: "test",role: 1)

# User.create!(name: 'test', email: 'test.@Email', password: "test",password_confirmation: "test",role: 0)

# メジャー猫種
CatBreed.create!(name: 'その他')
CatBreed.create!(name: 'ミックス（雑種）')
CatBreed.create!(name: 'アメリカンカール')
CatBreed.create!(name: 'アビシニアン')
CatBreed.create!(name: 'アメリカンショートヘアー')
CatBreed.create!(name: 'アメリカンボブテイル')
CatBreed.create!(name: 'アメリカンワイヤーヘア')
CatBreed.create!(name: 'エキゾチックショートヘア')
CatBreed.create!(name: 'エジプシャンマウ')
CatBreed.create!(name: 'オシキャット')
CatBreed.create!(name: 'オリエンタル')
CatBreed.create!(name: 'キムリック')
CatBreed.create!(name: 'コーニッシュレックス')
CatBreed.create!(name: 'コラット')
CatBreed.create!(name: 'サイベリアン')
CatBreed.create!(name: 'ジャパニーズボブテイル')
CatBreed.create!(name: 'シャム')
CatBreed.create!(name: 'シャルトリュー')
CatBreed.create!(name: 'シンガプーラ')
CatBreed.create!(name: 'スコティッシュフォールド')
CatBreed.create!(name: 'スノーシュー')
CatBreed.create!(name: 'スフィンクス')
CatBreed.create!(name: 'セルカークレックス')
CatBreed.create!(name: 'ソマリ')
CatBreed.create!(name: 'ターキッシュアンゴラ')
CatBreed.create!(name: 'ターキッシュバン')
CatBreed.create!(name: 'デボンレックス')
CatBreed.create!(name: 'トンキニーズ')
CatBreed.create!(name: 'ノルウェージャンフォレストキャット')
CatBreed.create!(name: 'バーマン')
CatBreed.create!(name: 'ハバナブラウン')
CatBreed.create!(name: 'バーミーズ')
CatBreed.create!(name: 'バリニーズ')
CatBreed.create!(name: 'ピクシーボブ')
CatBreed.create!(name: 'ヒマラヤン')
CatBreed.create!(name: 'ブリティッシュショートヘアー')
CatBreed.create!(name: 'ペルシャ')
CatBreed.create!(name: 'ベンガル')
CatBreed.create!(name: 'ボンベイ')
CatBreed.create!(name: 'マンクス')
CatBreed.create!(name: 'マンチカン')
CatBreed.create!(name: 'メインクーン')
CatBreed.create!(name: 'ラガマフィン')
CatBreed.create!(name: 'ラグドール')
CatBreed.create!(name: 'ラパーマ')
CatBreed.create!(name: 'ロシアンブルー')
# マイナー猫種
CatBreed.create!(name: 'アメリカンキューダ')
CatBreed.create!(name: 'アメリカンポリダクティル')
CatBreed.create!(name: 'アメリカンリングテイル')
CatBreed.create!(name: 'アラビアンマウ')
CatBreed.create!(name: 'アルパインリンクス')
CatBreed.create!(name: 'イジアン')
CatBreed.create!(name: 'ウラルレックス')
CatBreed.create!(name: 'エイジアン')
CatBreed.create!(name: 'オイイーボブ')
CatBreed.create!(name: 'オーストラリアンミスト')
CatBreed.create!(name: 'オホサスレス')
CatBreed.create!(name: 'オリエンタルバイカラー')
CatBreed.create!(name: 'カラーポイントショートヘアー')
CatBreed.create!(name: 'カリフォルニアスパングルド')
CatBreed.create!(name: 'キプロスアフロディーテ')
CatBreed.create!(name: 'キンカロー')
CatBreed.create!(name: 'クリッパーキャット')
CatBreed.create!(name: 'クリリアンボブテイル')
CatBreed.create!(name: 'サバンナ')
CatBreed.create!(name: 'サファリ')
CatBreed.create!(name: 'ジャーマンレックス')
CatBreed.create!(name: 'ジェネッタ')
CatBreed.create!(name: 'シャンティリー')
CatBreed.create!(name: 'スクークム')
CatBreed.create!(name: 'セイシェルワ')
CatBreed.create!(name: 'セイロンキャット')
CatBreed.create!(name: 'セレンゲティ')
CatBreed.create!(name: 'ソコケ')
CatBreed.create!(name: 'チートー')
CatBreed.create!(name: 'チャウシー')
CatBreed.create!(name: 'デザートリンクス')
CatBreed.create!(name: 'テネシーレックス')
CatBreed.create!(name: 'トイガー')
CatBreed.create!(name: 'トイボブ')
CatBreed.create!(name: 'ドウェルフ')
CatBreed.create!(name: 'ドラゴンリー')
CatBreed.create!(name: 'ドンスコイ')
CatBreed.create!(name: 'メヌエット（ナポレオン）')
CatBreed.create!(name: 'ネベロング')
CatBreed.create!(name: 'バーレイニディルムンキャット')
CatBreed.create!(name: 'ハイランドリンクス')
CatBreed.create!(name: 'ハバリ')
CatBreed.create!(name: 'バンビーノ')
CatBreed.create!(name: 'ピーターボールド')
CatBreed.create!(name: 'フォールデックス')
CatBreed.create!(name: 'ブラジリアンショートヘアー')
CatBreed.create!(name: 'ブランブル')
CatBreed.create!(name: 'ブリティッシュロングヘアー')
CatBreed.create!(name: 'マンダレイ')
CatBreed.create!(name: 'ミンスキン')
CatBreed.create!(name: 'メコンボブテイル')
CatBreed.create!(name: 'モハーベスポッテド')
CatBreed.create!(name: 'モハーベボブ')
CatBreed.create!(name: 'ユークレイニアンレフコイ')
CatBreed.create!(name: 'ヨークチョコレート')
CatBreed.create!(name: 'ヨーロピアンショートヘアー')
CatBreed.create!(name: 'ライコイ')
CatBreed.create!(name: 'ラムキン')


Cat.create!(
  name: 'ルビー', birthday: Date.new(2016, 7, 12), user_id: User.find_by(name: "上村 拓磨").id, gender: 1, cat_breed_id: CatBreed.find_by(name: "マンチカン").id
)

tags = ['うちの猫！','一押し！','飼い猫','家猫！','猫好きの人！']
tags.each do |tag_name|
  Tag.create!(name: tag_name)
end

user_avatar_images = Dir[Rails.root.join('public', 'user avatar initial data', '*.webp')]

20.times do |n|
    user = User.create!(
      name: Faker::Name.unique.name,
      email: Faker::Internet.unique.email,
      password: "test",
      password_confirmation: "test",
      avatar: File.open(user_avatar_images.sample),
      self_introduction: Faker::Lorem.sentence,
      role: 0
    )

    cat_avatar_images = Dir[Rails.root.join('public', 'cat avatar Initial data', '*.webp')]

    cat_breed = CatBreed.order("RANDOM()").first
    birthday_datetime = Faker::Time.between(from: 30.years.ago, to: DateTime.now)
    self_introductions = [
  "人懐っこいです！",
  "自慢の愛猫です！",
  "かわいいです！",
  "まだこの猫ちゃんの紹介については未記入だよ"
]
names = ['ムギ', 'ソラ','レオ','ココ','タマ','マロン','モモ','キナコ','リン','ルナ','マル']
    cat = Cat.create!(
      name: names.sample,
      birthday: birthday_datetime,
      user_id: user.id,
      gender: rand(0..1),
      avatar: File.open(cat_avatar_images.sample),
      self_introduction: self_introductions.sample,
      cat_breed_id: cat_breed.id
    )
    titles = ['今日も元気です！','かわいい！','見てください！','これがうちの子です！','癒されます']
    bodys = ['元気いっぱい！', 'きゃわわ', '見てみて〜', '何してるの〜？', 'かわいいー']

    cat_images = Dir[Rails.root.join('public', 'Initial data', '*.webp')]

    post = Post.create!(
      title: titles.sample,
      body: bodys.sample,
      photo: File.open(cat_images.sample),
      user_id: user.id,
      cat_id: cat.id
    )

  # タグをランダムに2つ紐づける（数は適宜変更可能）
  post.tags << Tag.where(name: tags.sample(2))

   # いいねをランダムに設定
rand(0..5).times do
  # 投稿にいいねをしていないユーザーを取得
  liker = User.where.not(id: user.id).where.not(id: post.likes.pluck(:user_id)).sample

  # 投稿にいいねをしていないユーザーがいる場合にのみいいねを作成
  if liker.present?
    Like.create!(
      user_id: liker.id,
      post_id: post.id
    )
  end
end

# ブックマークをランダムに設定
rand(0..5).times do
  # 投稿にブックマークをしていないユーザーを取得
  bookmarker = User.where.not(id: user.id).where.not(id: post.bookmarks.pluck(:user_id)).sample

  # 投稿にブックマークをしていないユーザーがいる場合にのみブックマークを作成
  if bookmarker.present?
    Bookmark.create!(
      user_id: bookmarker.id,
      post_id: post.id
    )
  end
end
  end

comments = ['あなたの猫かわいいですね！','かわいい！', 'Good!!']

  users = User.all
  20.times do
    user = users.sample
    posts = Post.all.sample

    rand(1..5).times do
      posts.comments.create!(
      body: comments.sample,
      user_id: user.id
    )
     end
  end

  all_cats = Cat.all

  all_cats.each do |cat|
    # Determine the random number of health records to create (1 to 3 in this example)
    number_of_records = rand(1..3)
  
    # Create health records for the current cat
    number_of_records.times do
      HealthRecord.create!(
        weight: rand(1..5), # Replace with your logic for weight
        note: Faker::Lorem.sentence,
        cat_id: cat.id
      )
    end
  end

# 20.times do |n|
#     user = User.create!(
#       name: Faker::Name.unique.name,
#       email: Faker::Internet.unique.email,
#       password: "test",
#       password_confirmation: "test",
#       role: 0
#     )
  
#     cat_breed = CatBreed.order("RANDOM()").first
#     cat = Cat.create!(
#       name: Faker::Name.unique.name,
#       birthday: Faker::Date.birthday,
#       user_id: user.id,
#       gender: rand(0..1),
#       cat_breed_id: cat_breed.id
#     )
  
#     Post.create!(
#       title: Faker::Book.unique.title,
#       body: Faker::Lorem.sentence,
#       user_id: user.id,
#       cat_id: cat.id
#     )
#   end
