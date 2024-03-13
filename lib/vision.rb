require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def image_analysis(image_file)
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"

      base64_image = image_type(image_file) # 写真拡張子のチェック
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'LABEL_DETECTION'
            }
          ]
        }]
      }.to_json

      vision_api_request(api_url, params) # VISION APIへリクエスト
    end

    private

    # 写真の拡張子が「HEIC」であれば一旦「jpeg」へ変換
    def image_type(image_file)
      if image_file.content_type == 'image/heic'
        # 画像の拡張子が「.heic」の場合
        heic_path = image_file.tempfile.path
        jpg_path = convert_heic_to_jpg(heic_path) # 拡張子を「jpg」へ変更する処理へ移行
        Base64.encode64(File.read(jpg_path))
      else
        # 他の画像タイプの場合（.jpg、.jpeg、.png、等々）
        Base64.encode64(image_file.tempfile.read)
      end
    end

    # 写真の拡張子が「Heic」だった場合、jpgへ変更する処理
    def convert_heic_to_jpg(heic_path)
      # MiniMagickを使用してHEIC画像を一時的に「.jpg」形式のファイルに変換する処理
      tempfile = Tempfile.new(['converted_image', '.jpg'])
      image = MiniMagick::Image.open(heic_path)
      image.format('jpg')
      image.write(tempfile.path)
      tempfile.path
    end

    # APIへリクエストする処理
    def vision_api_request(api_url, params)
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      result = JSON.parse(response.body)
      result_check(result) # ラベルのチェック処理
    end

    # 猫のラベルが存在するかチェック
    def result_check(result)
      error = result['responses'][0]['error']
      return false if error.present?

      labels = result['responses'][0]['labelAnnotations'].map { |annotation| annotation['description'].downcase }
      labels.include?('cat')
    end
  end
end
