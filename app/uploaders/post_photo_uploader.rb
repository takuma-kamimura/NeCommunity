class PostPhotoUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  def default_url # デフォルトの画像ファイル
    'c34caee90e20401e3fa0e8c574bdc298.jpg'
  end

  # version :index_size do
  #   process resize_and_pad: [1600, 900, '#f5ebdc', 'Center']
  #   process :convert_to_webp
  # end

  # def convert_to_webp
  #   manipulate! { |img| img.format('webp') }
  # end

  process resize_and_pad: [1600, 900, '#f5ebdc', 'Center']

  def filename
    return unless original_filename.present?

    # base_name = File.basename(original_filename, '.*')
    base_name = File.basename(original_filename, '.*')
    "#{base_name}.webp"
  end

  # def base_filename
  #   File.basename(original_filename, '.*')
  # end

  def extension_whitelist # 拡張子の制限
    %w[jpg jpeg gif png heic webp]
  end

  if Rails.env.production?
    storage :fog              # 本番時にS3にファイルを保存する
  else
    storage :file             # 開発・テスト時にはローカルにファイルを保存する
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_allowlist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
