class CatBreedsController < ApplicationController
  def index
    q = params[:q] # ひらがなをカタカナに変換
    q = q.tr('あ-ん', 'ア-ン')
    @q = CatBreed.ransack(name_start: q)
    @cat_breeds = @q.result(distinct: true)
    q_check
    respond_to do |format|
      format.js
    end
  end

  private

  # 文字が「そ」か「雑」かを判定。
  def q_check
    if params[:q] == 'そ'
      @q = CatBreed.ransack(name_start: params[:q])
      @cat_breeds += @q.result(distinct: true)
    elsif params[:q] == '雑'
      @q = CatBreed.ransack(name_cont: params[:q])
      @cat_breeds += @q.result(distinct: true)
    end
  end
end
