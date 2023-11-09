require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0


     # 2行追記:デフォルトのlocaleを日本語(:ja)にする.
     config.i18n.default_locale = :ja
     config.time_zone = 'Tokyo'
     config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

     #下記コード、「rails generate」コマンドで「helperファイル・testファイル、ルーティングの記述」が生成されないように設定。
     config.generators do |g|
      g.helper false #helperを生成しない
      g.test_framework false #testファイルを生成しない
      g.skip_routes true   #ルーティングを生成しない
     end

  end
end
