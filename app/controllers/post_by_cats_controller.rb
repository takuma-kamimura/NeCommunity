class PostByCatsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    cat_ids = params[:cat_id]
    @cat = Cat.find(cat_ids)
    @post_by_cats = Post.where(cat_id: cat_ids).order(created_at: :desc).page(params[:page])
  end
end
