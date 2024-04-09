# ネコミュニティ

![image](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/f29bc254-0578-4370-9d48-7c537f1f5ad3)

![](https://img.shields.io/badge/Ruby-v3.2.2-CC0000?logo=Ruby&logoColor=CC0000)
![](https://img.shields.io/badge/Ruby_On_Rails-v7.0.8-CC0000?logo=Ruby-on-Rails&logoColor=CC0000)
![](https://img.shields.io/badge/TailWind_CSS-v3.3.5-2396F3?logo=tailwindcss)
![](https://img.shields.io/badge/Docker-gray?logo=Docker)
![](https://img.shields.io/badge/Nginx-gray?logo=Nginx&logoColor=269539)
![](https://img.shields.io/badge/AWS_S3-gray?logo=amazon-aws&logoColor=FCC624)
![](https://img.shields.io/badge/Heroku-gray?logo=Heroku&logoColor=430098)

## ■サービス概要

* 猫好き専門の猫画像投稿型SNSサービスです。猫好きな人達がお互いの猫の画像を投稿して自慢し合い、評価し合えます。飼っている猫を登録して、投稿時に飼っている猫を投稿内容に紐付けることができます。好きな地名を入力すると地名周辺の猫専門の動物病院を検索することができます。

▼**サービスURL**

https://neko-community.com/

▼**開発者「X」**

https://twitter.com/tkm9353

## ■このサービスへの想い

* 実家で猫を飼っていて、実家暮らし時代から猫が大好きなので猫に関するWebアプリを作りたいと思ったため。

* 自分の猫を自慢できる場を作りたいと思ったため。他の人も自分達の猫を自慢できるコミュニティを作りたいと思ったため。

* 「他の人はどんな猫を飼っているのだろう？」と気軽に知る機会があったら良いなと考えたため。

## ■機能一覧
| 猫登録機能| ユーザープロフィール編集機能 | 投稿機能 |
|------|------|-----|
| ![Readme-cat-create-ezgif com-video-to-gif-converter](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/f85b20f7-06f1-4de3-9703-f0630ec3ca1f)| ![profile-edit](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/90b210d6-f862-454e-8f98-0db6e795fef6) | ![post-create](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/0b6d37a5-e664-45b3-b942-f8133058f7b4)|

| コメント投稿機能 |　 Line通知機能 | 動物病院検索機能 |
|------|------|-----|
| ![comment-create](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/69dee272-4b55-4783-b908-b1d9f5a8accc)| ![Line-message](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/95e27420-1a2c-4d41-a90e-6bcaffd0ebc7) |![map](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/3214c64b-97f8-4968-8d74-c43e26e9df0e) |

## ■使用技術一覧


| 項目           | 技術                                                                                          |
|----------------|---------------------------------------------------------------------------------------------|
| フロントエンド | Hotwire,JavaScript, Tailwind css, Boot Strap icons,daisy Ul| 
| バックエンド  |Ruby 3.2.2 , Ruby on Rails 7.0.8| 
| データベース | PostgreSQL| 
| 環境構築    | Docker / docker-compose / Nginx | 
| インフラ     | Heroku, AWS(S3)|                
| API        |  Google Cloud Vision API,  Google Geocoding API,  Google Maps JavaScript API,  Google Places API,  Line-bot-api | 

## 画面遷移図

* https://www.figma.com/file/jUooXyrTJY2d0CwGplCvGh/%E3%83%8D%E3%82%B3%E3%83%9F%E3%83%A5%E3%83%8B%E3%83%86%E3%82%A3?type=design&mode=design&t=ZmynGkavsBR2zSbI-1

## ER図

![ネコミュニティ_ER図 drawio](https://github.com/takuma-kamimura/NeCommunity/assets/134459703/119902dc-883f-4081-9ea3-5cd690775c79)

