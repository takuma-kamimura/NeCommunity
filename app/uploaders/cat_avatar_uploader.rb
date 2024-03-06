class CatAvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url # デフォルトの画像ファイル
    'cat_default.webp'
  end

  process :convert_to_webp

  def convert_to_webp
    manipulate! do |img|
      img.auto_orient # Exif情報に基づいて回転 画像が勝手に回転して保存されていたのでこの処理を追加した
      img.strip       # Exif情報を取り除く 画像が勝手に回転して保存されていたのでこの処理を追加した
      img.format 'webp'
      img
    end
  end

  #🔥拡張子を.webpで保存
  def filename
    super.chomp(File.extname(super)) + '.webp' if original_filename.present?
  end

  # def extension_whitelist # 拡張子の制限
  def extension_allowlist # rspecにて「def extension_whitelist」は廃止となったので左のコードへ変更
    %w[jpg jpeg gif png heic webp]
  end

  if Rails.env.production?
    storage :fog              # 本番時にS3にファイルを保存する
  else
    storage :file             # 開発・テスト時にはローカルにファイルを保存する
  end
end
