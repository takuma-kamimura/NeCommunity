class AutocompletesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  # オートコンプリート機能
  def index
    cats = Post.joins(:cat).where('cats.name LIKE :q', q: "%#{params[:q]}%")
    users = Post.joins(:user).where('users.name LIKE :q', q: "%#{params[:q]}%")
    posts = Post.where('title LIKE :q OR body LIKE :q', q: "%#{params[:q]}%")
    @posts = (cats + users + posts).uniq
      respond_to do |format|
        format.js
      end
  end
end
