class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]

  def index
    @q = Post.ransack(params[:q])
    # @posts = Post.includes(:user).order(created_at: :desc)
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
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
    if post_params[:photo].present?
      result = Vision.image_analysis(post_params[:photo])
      if result
        if @post.update(post_params)
          flash[:success] = t('messages.post.update')
          # モデルのメソッド処理(update_tags)に入る
          @post.update_tags(@tags)
          redirect_to posts_path
        else
          # @post = post_params
          flash[:danger] = t('messages.post.update_faild')
          # redirect_to edit_post_path(@post), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
          render :edit, status: :unprocessable_entity
        end
      else
        flash[:danger] =  t('messages.post.cat_validation')
        render :edit, status: :unprocessable_entity
      end
    else
      if @post.update(post_params)
        flash[:success] = t('messages.post.update')
        # モデルのメソッド処理(update_tags)に入る
        @post.update_tags(@tags)
        redirect_to posts_path
      else
        # @post = post_params
        flash[:danger] = t('messages.post.update_faild')
        # redirect_to edit_post_path(@post), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def create
    @post = Post.new(post_params)
    @tags = params[:post][:name].split(',') # 「split()」でカンマ区切りにしている。
    if post_params[:photo].present?
      # 画像を添付した場合の処理
      result = Vision.image_analysis(post_params[:photo])
      if result
        if @post.save
          # 添付ファイルが猫の画像だった場合
          flash[:success] = t('messages.post.create')
          @post.save_tags(@tags)
          redirect_to posts_path
        else
          # 添付ファイルが猫とは関係ない画像だった場合
          flash[:danger] = t('messages.post.create_faild')
          render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
          @post = Post.new(post_params) #  上の「render :new, status: :unprocessable_entity」より後に書かないと「エラーメッセージが格納されない。何も入っていない必要があるから。」
        end
      else
        flash[:danger] =  t('messages.post.cat_validation')
        render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
        @post = Post.new(post_params)
      end
    else
      # 画像を添付していない場合の処理
      if @post.save
        flash[:success] = t('messages.post.create')
        @post.save_tags(@tags)
        redirect_to posts_path
      else
        flash[:danger] = t('messages.post.create_faild')
        render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
        @post = Post.new(post_params) #  上の「render :new, status: :unprocessable_entity」より後に書かないと「エラーメッセージが格納されない。何も入っていない必要があるから。」
      end
    end
  end

  def destroy
    return unless set_post.user_id == current_user.id

    @post = Post.find_by(id: params[:id])
    @post.destroy!
    flash[:success] = t('messages.post.delete')
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

  # current_userの猫と同じ猫種に関する投稿
  def samebreedcats
    @q = Post.ransack(params[:q])
    # @samebreedcats =
      # ログインユーザーが飼っている全ての猫の猫種を取得
    current_cat_breed_ids = current_user.cats.pluck(:cat_breed_id)
    # 同じ猫種の猫のIDリストを取得
    same_breed_cat_ids = Cat.where(cat_breed_id: current_cat_breed_ids).pluck(:id)
    # 同じ猫種の猫が投稿した投稿を取得
    @samebreedcats = Post.where(cat_id: same_breed_cat_ids)
  end

  # 指定した猫種と同じ猫種に関する投稿
  def specifycats
    @q = Post.ransack(params[:q])

    # ログインユーザーの猫の猫種を取得
    current_cat_breed_id = params[:cat_breed_id]

    # 同じ猫種の猫のIDリストを取得
    same_breed_cat_ids = Cat.where(cat_breed_id: current_cat_breed_id).pluck(:id)

    # 同じ猫種の猫が投稿した投稿を取得
    @specifycats = Post.where(cat_id: same_breed_cat_ids)
    @cat_breed = CatBreed.find(params[:cat_breed_id])
  end

  # オートコンプリート機能
  def autocomplete
    # @posts = Post.where("title LIKE :q OR body LIKE :q", q: "%#{params[:q]}%")

    # @posts = Post.joins(:user)
    #          .where("posts.title LIKE :q OR posts.body LIKE :q OR users.name LIKE :q", q: "%#{params[:q]}%")

    # @posts = Post.joins(:user, :cat)
    # .where("posts.title LIKE :q OR posts.body LIKE :q OR users.name LIKE :q OR cats.name LIKE :q", q: "%#{params[:q]}%")

  cats = Post.joins(:cat).where("cats.name LIKE :q", q: "%#{params[:q]}%")
  users = Post.joins(:user).where("users.name LIKE :q", q: "%#{params[:q]}%")
  posts = Post.where("title LIKE :q OR body LIKE :q", q: "%#{params[:q]}%")

  @posts = (cats + users + posts).uniq
    # render json: @posts.select(:id, :title)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :photo, :photo_cache, :cat_id).merge(user_id: current_user.id)
  end
end
