class MapsController < ApplicationController

  def index
    # Google Maps Places API を使用して検索
    @search_results = GoogleMapsService.search_shops_by_location(params[:location])
  end

end
