require "base64"
require "json"
require "net/https"

module Vision
  class << self
    def image_analysis(image_file)
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"
      if image_file.content_type == "image/heic"
        # 画像の拡張子が「.heic」の場合
        heic_path = image_file.tempfile.path
        jpg_path = convert_heic_to_jpg(heic_path)
        base64_image = Base64.encode64(File.read(jpg_path))
      else
        # 他の画像タイプの場合（.jpg、.jpeg、.png、等々）
        base64_image = Base64.encode64(image_file.tempfile.read)
      end
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: "LABEL_DETECTION"
            }
          ]
        }]
      }.to_json
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      response = https.request(request, params)
      result = JSON.parse(response.body)
      if (error = result["responses"][0]["error"]).present?
        raise error["message"]
      else
        labels = result["responses"][0]["labelAnnotations"].map { |annotation| annotation["description"].downcase }
        # ここで猫のラベルをチェックする（例: "cat"）
        if labels.include?("cat")
          true
        else
          false
        end
      end
    end

    private

    def convert_heic_to_jpg(heic_path)
      # MiniMagickを使用してHEIC画像を一時的に「.jpg」形式のファイルに変換
      tempfile = Tempfile.new(['converted_image', '.jpg'])
      image = MiniMagick::Image.open(heic_path)
      image.format('jpg')
      image.write(tempfile.path)
      tempfile.path
    end
  end
end
