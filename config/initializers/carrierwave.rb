require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], #awsのIAMのアクセスキー
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], #awsのIAMのシークレットアクセスキー
      region: 'ap-northeast-1' #バケットの作成で設定した地域(東京で設定した場合は左と一緒)
    }
    config.fog_directory = ENV['AWS_BUCKET_NAME'] #バケット名
    config.cache_storage = :fog     # 本番時はS3にファイルを保存する
  else
    config.storage = :file          # 開発・テスト時はローカルにファイルを保存する
  end

end