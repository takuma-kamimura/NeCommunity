class LikeListsController < ApplicationController
  # ログインユーザーがいいねした一覧表示
  def index
    @q = current_user.like_posts.ransack(params[:q])
    @like_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
  end
end
