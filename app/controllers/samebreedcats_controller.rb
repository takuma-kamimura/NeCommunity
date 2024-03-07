class SamebreedcatsController < ApplicationController
  # current_userの猫と同じ猫種に関する投稿
  def index
    @q = Post.ransack(params[:q])
    # ログインユーザーが飼っている全ての猫の猫種を取得
    current_cat_breed_ids = current_user.cats.pluck(:cat_breed_id)
    # 同じ猫種の猫のIDリストを取得
    same_breed_cat_ids = Cat.where(cat_breed_id: current_cat_breed_ids).pluck(:id)
    # 同じ猫種の猫が投稿した投稿を取得
    @samebreedcats = Post.where(cat_id: same_breed_cat_ids).order(created_at: :desc).page(params[:page])
  end
end
