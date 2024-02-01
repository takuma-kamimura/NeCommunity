# app/services/google_maps_service.rb
class GoogleMapsService
    require "net/http"
    require "uri"

    BASE_URL = 'https://maps.googleapis.com/maps/api/place'
    API_KEY = ENV['PLACES_API_KEY']
    LANGUAGE = 'ja'.freeze

    # mapsコントローラーのseachメソッドで利用。入力された地名や市名を受け取る
    def self.search_veterinaries_by_location(location)
      query = CGI.escape("猫+動物病院+in+#{location}")
      uri = URI.parse("#{BASE_URL}/textsearch/json?query=#{query}&key=#{API_KEY}&language=#{LANGUAGE}")
      res = Net::HTTP.get_response(uri)
      parsed_body = JSON.parse(res.body)
      #formatted_results = format_results(JSON.parse(res.body)) コメントにしてページに表示されなくなった
      # "<ul>#{formatted_results}</ul>"
    end

    def self.veterinary(place_id)
        fields = "name,formatted_address,geometry,photos,website"
        uri = URI.parse("#{BASE_URL}/details/json?place_id=#{place_id}&fields=#{fields}&key=#{API_KEY}&language=#{LANGUAGE}")
        res = Net::HTTP.get_response(uri)
        # res.body
        parsed_body = JSON.parse(res.body)
    end

    def self.veterinary_photo(veterinary)
      photos = veterinary["result"]["photos"]
    # 写真が存在する場合、最初の写真の URL を取得して表示
      if photos && photos.length > 0
        photoReference = photos[0]["photo_reference"]
        # return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photoReference}&key=#{ENV['PLACES_API_KEY']}"
        return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photoReference}&key=#{ENV['PLACES_API_KEY']}"
      end
    end

    # private
  
    # def self.format_results(results)
    #     # 結果をHTMLに整形するロジックを追加
    #     results['results'].map do |result|
    #       name = result['name']
    #       address = result['formatted_address']
    #       latitude = result['geometry']['location']['lat']
    #       longitude = result['geometry']['location']['lng']
      
    #       "<li>#{name}: #{address} (緯度: #{latitude}, 経度: #{longitude})</li>"
    #     end.join('')
    # end
end
