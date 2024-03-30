class GoogleMapsService
    require 'net/http'
    require 'uri'

    BASE_URL = 'https://maps.googleapis.com/maps/api/place'
    API_KEY = ENV['PLACES_API_KEY']
    LANGUAGE = 'ja'.freeze

    # mapsコントローラーのseachメソッドで利用。入力された地名や市名を受け取る
    def self.search_veterinaries_by_location(location)
      query = CGI.escape("猫+動物病院+in+#{location}")
      uri = URI.parse("#{BASE_URL}/textsearch/json?query=#{query}&key=#{API_KEY}&language=#{LANGUAGE}")
      res = Net::HTTP.get_response(uri)
      parsed_body = JSON.parse(res.body)
    end

    # mapsコントローラーのshowメソッドで利用。取得したPlace_idを使い、施設の情報を得る。
    def self.veterinary(place_id)
        fields = 'name,formatted_address,geometry,photos,website'
        uri = URI.parse("#{BASE_URL}/details/json?place_id=#{place_id}&fields=#{fields}&key=#{API_KEY}&language=#{LANGUAGE}")
        res = Net::HTTP.get_response(uri)
        parsed_body = JSON.parse(res.body)
    end

    # mapsコントローラーのshowメソッドで利用。取得した施設の情報を使い、施設の画像を得る。
    def self.veterinary_photo(veterinary)
      photos = veterinary['result']['photos']
      # 写真が存在する場合、最初の写真の URL を取得して表示
      return unless photos && photos.length > 0

      photoReference = photos[0]['photo_reference']
      "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photoReference}&key=#{API_KEY}"
    end
end
