class MapsController < ApplicationController

  def index
    # Google Maps Places API を使用して検索
    @search_results = GoogleMapsService.search_veterinaries_by_location(params[:location])
    @search_results_json = @search_results.to_json
    # binding.pry
    respond_to do |format|
        format.html
        format.json { render json: { search_results: @search_results } }
      end
  end

  # app/controllers/maps_controller.rb
  def search
    @search_results = GoogleMapsService.search_veterinaries_by_location(params[:location])
    @search_results_json = @search_results.to_json
   
    # binding.pry
    respond_to do |format|
        format.html
        format.json { render json: { results: @search_results } }
      end
  end

  def show
    # @veterinary = params[:id]
    # @veterinary["result"]["formatted_address"] でハッシュに紐づけられているデータが取り出せる。
    @veterinary = GoogleMapsService.veterinary(params[:id])
    # photos =  @veterinary["result"]["photos"]
    # 写真が存在する場合、最初の写真の URL を取得して表示
    # if photos && photos.length > 0
    # photoReference = photos[0]["photo_reference"]
    # @photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photoReference}&key=#{ENV['PLACES_API_KEY']}"
    # binding.pry
    # end

    @photoUrl = GoogleMapsService.veterinary_photo(@veterinary)
    # binding.pry
  end
end
