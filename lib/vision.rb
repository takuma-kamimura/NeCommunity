require "base64"
require "json"
require "net/https"

module Vision
  class << self
    def image_analysis(image_file)
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"
      base64_image = Base64.encode64(image_file.tempfile.read)
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
  end
end
