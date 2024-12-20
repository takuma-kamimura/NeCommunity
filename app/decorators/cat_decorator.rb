class CatDecorator < ApplicationDecorator
  delegate_all

  # 猫の名前のオス・メスの表示切り替え
  def cat_name
    if object.Female?
      "#{object.name}ちゃん"
    else
      "#{object.name}くん"
    end
  end

  # 猫の年齢の計算
  def cat_age
    today = Time.zone.today
    this_years_birthday = Time.zone.local(today.year, birthday.month, birthday.day)
    age = today.year - birthday.year
    if today < this_years_birthday
      age -= 1
    end
    age = 0 if age.negative?
    "#{age}歳"
  end
end
