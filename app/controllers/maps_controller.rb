class MapsController < ApplicationController

  def index
    # Google Maps Places API を使用して検索
    @search_results = GoogleMapsService.search_shops_by_location(params[:location])
    @search_results_json = @search_results.to_json
    # binding.pry
    render json: { search_results: @search_results }
    # render :index
  end

end
