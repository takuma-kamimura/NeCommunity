source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.8"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

gem 'sorcery' # ユーザーログイン機能追加のため。

gem 'pry-byebug' # テスト用

gem 'rails-i18n' # 日本語対応

gem 'carrierwave' # 写真アップロード機能

gem 'jquery-rails' # jquery

gem 'simple_form' # シンプルフォーム

gem 'enum_help' # enumで表記の切り替え

gem 'draper' # デコレーター

gem 'ransack' # 検索機能

gem 'letter_opener_web' # 開発環境用メーラー

gem 'config' # 環境設定用。

gem 'dotenv-rails' # .envファイル読み込み用。

gem "sassc-rails"

gem 'fog-aws' # awss3画像アップロード用

gem 'mini_magick' # 画像変換

# gem "faker" # 初期データ導入

gem 'meta-tags' # ツイッターOGP画像設定用

gem 'line-bot-api' # Lineメッセージ用

gem 'kaminari' # ページネーションの追加

# gem 'high_voltage' # before_action :require_loginが発生して使えなかった

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem "faker" # ダミーデータ作成用
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'rubocop'
  gem 'rubocop-rails'
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver", '4.25.0' # RspecでCapybaraが動かなくなったため、バージョンを上げて更新した。
  gem "webdrivers"
end
