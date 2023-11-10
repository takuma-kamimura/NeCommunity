class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
    @cats = current_user.cats.order(created_at: :asc) # 生成した順番に取得する
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    return unless set_post.user_id == current_user.id

    @post = Post.find(params[:id])
  end

  def update
    return unless set_post.user_id == current_user.id

    @post = Post.find_by(id: params[:id])
    if @post.update(post_params)
      # flash[:success] = t('board.board_update')
      redirect_to posts_path
    else
      @post = post_params
      # flash[:danger] = t('board.board_update_failed')
      redirect_to edit_post_path(@post), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
    end
  end

  def create
    @post = Post.new(post_params)
    # @board.user_id = current_user.id
    # binding.pry
    if @post.save!
      # flash[:success] = t('board.board_create')
      redirect_to posts_path
    else
      # flash.now[:danger] = t('board.board_create_failed')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
      @post = Post.new(post_params) #  上の「render :new, status: :unprocessable_entity」より後に書かないと「エラーメッセージが格納されない。何も入っていない必要があるから。」
    end
  end

  def destroy
    return unless set_post.user_id == current_user.id

    @post = Post.find_by(id: params[:id])
    @post.destroy!
    # flash[:success] = t('board.board_deleted')
    redirect_to posts_path, status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    # params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache).merge(user_id: current_user.id, cat_breed_id: params[:cat_breed_id])
    params.require(:post).permit(:title, :body, :photo, :photo_cache, :cat_id).merge(user_id: current_user.id)
  end
  
end
