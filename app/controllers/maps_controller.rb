class MapsController < ApplicationController

  def search
    # パラメータで地名や都市名などのキーワードを受け取り、GoogleマップAPIに処理を渡す。
    @search_results = GoogleMapsService.search_veterinaries_by_location(params[:location])
    @search_results_json = @search_results.to_json

    # html形式にして表示して受け取ったデータをjson形式にしてデータを返す。
    respond_to do |format|
        format.html
        format.json { render json: { results: @search_results } }
      end
  end

  def show
    # 「@veterinary["result"]["formatted_address"] 」でハッシュに紐づけられているデータが取り出せる。
    # 選択した病院のplace_idを受け取ってGoogle Place APIに渡して、動物病院の詳細情報を受け取る。
    @veterinary = GoogleMapsService.veterinary(params[:id])

    # @veterinary["result"]["photos"]に取得した施設の「写真一覧」が入っている。
    @photoUrl = GoogleMapsService.veterinary_photo(@veterinary)
  end
end
