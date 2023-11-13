class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @q = Post.ransack(params[:q])
    # @posts = Post.includes(:user).order(created_at: :desc)

    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)

    # @boards = @q.result(distinct: true).includes(:user).order('created_at desc').page(params[:page])

  end

  def new
    @post = Post.new
    @cats = current_user.cats.order(created_at: :asc) # 生成した順番に取得する
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    # 下記、空の場合は下の処理は行わない
    return if @post.blank?

    @comments = @post.comments.includes(:post).order(created_at: :desc)
  end

  def edit
    return unless set_post.user_id == current_user.id

    @post = Post.find(params[:id])
    @tags = @post.tags.pluck(:name).join(',') # 「join」でカンマを区切り文字として間に入れている。
  end

  def update
    return unless set_post.user_id == current_user.id

    @post = Post.find_by(id: params[:id])
    @tags = params[:post][:name].split(',') # 「split()」でカンマ区切りにしている。
    if @post.update(post_params)
      # flash[:success] = t('board.board_update')
      # モデルのメソッド処理(update_tags)に入る
      @post.update_tags(@tags)
      redirect_to posts_path
    else
      @post = post_params
      # flash[:danger] = t('board.board_update_failed')
      redirect_to edit_post_path(@post), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
    end
  end

  def create
    # binding.pry
    @post = Post.new(post_params)
    @tags = params[:post][:name].split(',') # 「split()」でカンマ区切りにしている。
    # binding.pry
    if @post.save!
      # flash[:success] = t('board.board_create')
      @post.save_tags(@tags)
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

  def likes
    @q = current_user.like_posts.ransack(params[:q])
    @like_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
  end

  def bookmarks
    @q = current_user.bookmark_posts.ransack(params[:q])
    @bookmark_posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
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
