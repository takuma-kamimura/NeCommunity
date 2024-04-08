# ネコミュニティ

![image](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/f29bc254-0578-4370-9d48-7c537f1f5ad3)

## ■サービス概要

* 猫好き専門の猫画像投稿型SNSサービスです。猫好きな人達がお互いの猫の画像を投稿して自慢し合い、評価し合えます。飼っている猫を登録して、投稿時に飼っている猫を投稿内容に紐付けることができます。好きな地名を入力すると地名周辺の猫専門の動物病院を検索することができます。

▼**サービスURL**

https://neko-community.com/

▼**開発者「X」**

https://twitter.com/tkm9353

## ■このサービスへの想い

* 実家で猫を飼っていて、実家暮らし時代から猫が大好きなので何かしら猫に関するWebサイトを作りたいと思ったため。

* 自分の猫を自慢できる場を作りたいと思ったため。他の人も自分達の猫を自慢できるコミュニティを作りたいと思ったため。

* 「他の人はどんな猫を飼っているのだろう？」と気軽に知る機会があったら良いなと考えたため。

* 猫を飼っている中で「他の人はこんな時、どうしているのだろう？」と疑問が湧いた時に気軽に相談し合えるコミュニティがあれば助かると思ったため。

## ■使用技術一覧

| 項目           | 技術                                                                                          |
|----------------|---------------------------------------------------------------------------------------------|
| フロントエンド | Hotwire,JavaScript, Tailwind css, Boot Strap icons,daisy Ul| 
| バックエンド  |Ruby 3.2.2 , Ruby on Rails 7.0.8| 
| データベース | PostgreSQL| 
| 環境構築    | Docker / docker-compose / Nginx | 
| インフラ     | Heroku, AWS(S3)|                
| API        |  Google Cloud Vision API,  Google Geocoding API,  Google Maps JavaScript API,  Google Places API,  Line-bot-api | 

## ■現在使用を想定しているgem
```
gem 'sorcery' # ユーザー新規登録、ログイン

gem 'rails-i18n' # 日本語翻訳機能

gem 'draper' # デコレータ機能

gem 'ransack'　# 検索機能

gem 'kaminari'　# ページネーション

gem 'kaminari-i18n'　# ページネーション日本語化

gem 'carrierwave'　# 画像アップロード機能。なるべくActiveStorageよりこちらを検討。

gem 'enum_help'　# 管理者機能追加のため

gem 'faraday'　# APIを使う時に検討する。「Faraday.get "URL"」でリクエストできるようになる。

gem 'rails-autocomplete' # オートコンプリート。Stimulus Autocompleteのどちらかを選び検討。

gem 'rmagick'　# 画像の加工用として

gem 'config' # 環境ごとに定数を管理するために検討

gem "faker"　# テスト時のダミーデータの作成のため

gem 'pry-byebug' # テスト用
```

## 画面遷移図

* https://www.figma.com/file/5O5VhEaXhD97rPYlHKn594/%E3%83%8D%E3%82%B3%E3%83%9F%E3%83%A5%E3%83%8B%E3%83%86%E3%82%A3%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&node-id=0-1&mode=design&t=H9w9qXO6RY0f2Zmg-0

## ER図

* https://drive.google.com/file/d/1F3CTPePaqftGfPdWUV1-0PTUULaKLmPf/view?usp=sharing
