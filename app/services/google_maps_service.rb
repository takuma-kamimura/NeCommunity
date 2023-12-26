# app/services/google_maps_service.rb
class GoogleMapsService
    require "net/http"
    require "uri"
  
    BASE_URL = 'https://maps.googleapis.com/maps/api/place'
    API_KEY = ENV['PLACES_API_KEY']
    LANGUAGE = 'ja'.freeze
  
    def self.search_shops_by_location(location)
      query = CGI.escape("猫+動物病院+in+#{location}")
      uri = URI.parse("#{BASE_URL}/textsearch/json?query=#{query}&key=#{API_KEY}&language=#{LANGUAGE}")
      res = Net::HTTP.get_response(uri)
      parsed_body = JSON.parse(res.body)
      #formatted_results = format_results(JSON.parse(res.body)) コメントにしてページに表示されなくなった
      # "<ul>#{formatted_results}</ul>"
    #   binding.pry
    end
  
    private
  
    def self.format_results(results)
        # 結果をHTMLに整形するロジックを追加
        results['results'].map do |result|
          name = result['name']
          address = result['formatted_address']
          latitude = result['geometry']['location']['lat']
          longitude = result['geometry']['location']['lng']
      
          "<li>#{name}: #{address} (緯度: #{latitude}, 経度: #{longitude})</li>"
        end.join('')
      end
  end