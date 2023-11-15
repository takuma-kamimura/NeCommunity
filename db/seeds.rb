# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: '上村 拓磨', email: 'jjd.swt-c.5@docomo.ne.jp', password: "test",password_confirmation: "test",role: 1)

User.create!(name: 'test', email: 'test.@Email', password: "test",password_confirmation: "test",role: 0)


CatBreed.create!(name: 'その他')
CatBreed.create!(name: 'アメリカンショートヘア')
CatBreed.create!(name: 'マンチカン')
CatBreed.create!(name: 'ラグドール')
CatBreed.create!(name: 'スコティッシュフォールド')
CatBreed.create!(name: 'ノルウェージャンフォレストキャット')
CatBreed.create!(name: 'ロシアンブルー')


Cat.create!(
  name: 'ルビー', birthday: Date.new(2016, 7, 12), user_id: User.find_by(name: "上村 拓磨").id, gender: 1, cat_breed_id: CatBreed.find_by(name: "マンチカン").id
)

Cat.create!(
  name: 'ルビー2', birthday: 2016/07/12, user_id: User.find_by(name: "上村 拓磨").id, gender: 1, cat_breed_id: CatBreed.find_by(name: "ラグドール").id
)

Cat.create!(
  name: 'ルビー3', birthday: 2016/07/12, user_id: User.find_by(name: "上村 拓磨").id, gender: 1, cat_breed_id: CatBreed.find_by(name: "その他").id
)

20.times do |n|
    user = User.create!(
      name: Faker::Name.unique.name,
      email: Faker::Internet.unique.email,
      password: "test",
      password_confirmation: "test",
      role: 0
    )
  
    cat_breed = CatBreed.order("RANDOM()").first
    cat = Cat.create!(
      name: Faker::Name.unique.name,
      birthday: Faker::Date.birthday,
      user_id: user.id,
      gender: rand(0..1),
      cat_breed_id: cat_breed.id
    )
  
    Post.create!(
      title: Faker::Book.unique.title,
      body: Faker::Lorem.sentence,
      user_id: user.id,
      cat_id: cat.id
    )
  end
