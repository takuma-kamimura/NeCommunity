class MapsController < ApplicationController

  def index
    # Google Maps Places API を使用して検索
    @search_results = GoogleMapsService.search_shops_by_location(params[:location])
    @search_results_json = @search_results.to_json
    # binding.pry
    respond_to do |format|
        format.html
        format.json { render json: { search_results: @search_results } }
      end
  end

  # app/controllers/maps_controller.rb
  def search
    @search_results = GoogleMapsService.search_shops_by_location(params[:location])
    @search_results_json = @search_results.to_json
   
    # binding.pry
    respond_to do |format|
        format.html
        format.json { render json: { results: @search_results } }
      end
  end

end
