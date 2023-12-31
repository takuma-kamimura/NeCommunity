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
    binding.pry
    # @veterinary = params[:id]
    # @veterinary["result"]["formatted_address"] でハッシュに紐づけられているデータが取り出せる。
    @veterinary = GoogleMapsService.veterinary(params[:id])
    binding.pry
  end

end
