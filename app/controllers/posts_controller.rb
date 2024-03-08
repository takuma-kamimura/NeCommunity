class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show autocomplete]

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(params[:page])
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
    return tags_over_check if @tags.count > 3

    if post_params[:photo].present?
      # 画像を添付した場合の処理
      result = Vision.image_analysis(post_params[:photo])
      if result
        update_has_image # 添付画像が猫の画像だった場合の処理
      else
        update_bad_image # 添付画像が猫の画像以外の場合の処理
      end
    else
      update_not_image # 画像を添付していない場合の処理
    end
  end

  def create
    @post = Post.new(post_params)
    @tags = params[:post][:name].split(',') # 「split()」でカンマ区切りにしている。
    return tags_over_check if @tags.count > 3

    if post_params[:photo].present?
      # 画像を添付した場合の処理
      result = Vision.image_analysis(post_params[:photo])
      if result
        create_has_image # 添付画像が猫の画像だった場合の処理
      else
        create_bad_image # 添付画像が猫の画像以外の場合の処理
      end
    else
      create_not_image # 画像を添付していない場合の処理
    end
  end

  def destroy
    return unless set_post.user_id == current_user.id

    @post = Post.find_by(id: params[:id])
    @post.destroy!
    flash[:success] = t('messages.post.delete')
    redirect_to posts_path, status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
  end

  # オートコンプリート機能
  def autocomplete
  cats = Post.joins(:cat).where('cats.name LIKE :q', q: "%#{params[:q]}%")
  users = Post.joins(:user).where('users.name LIKE :q', q: "%#{params[:q]}%")
  posts = Post.where('title LIKE :q OR body LIKE :q', q: "%#{params[:q]}%")
  @posts = (cats + users + posts).uniq
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

  # 新規作成時、猫の画像を添付していた場合の処理
  def create_has_image
    if @post.save
      # 添付ファイルが猫の画像だった場合
      flash[:success] = t('messages.post.create')
      @post.save_tags(@tags)
      redirect_to posts_path
    else
      flash.now[:danger] = t('messages.post.create_faild')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
      @post = Post.new(post_params) #  上の「render :new, status: :unprocessable_entity」より後に書かないと「エラーメッセージが格納されない。何も入っていない必要があるから。」
    end
  end

  # 新規作成時、猫以外の画像を添付していた場合の処理
  def create_bad_image
    @post.photo = nil # renderで戻る前に画像をnillにする処理
    flash.now[:danger] =  t('messages.post.cat_validation')
    render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
  end

  # 新規作成時、画像を添付していない場合の処理
  def create_not_image
    if @post.save
      flash[:success] = t('messages.post.create')
      @post.save_tags(@tags)
      redirect_to posts_path
    else
      flash.now[:danger] = t('messages.post.create_faild')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
      @post = Post.new(post_params) # 上の「render :new, status: :unprocessable_entity」より後に書かないと「エラーメッセージが格納されない。何も入っていない必要があるから。」
    end
  end

  # 投稿更新時、猫の画像を添付していた場合の処理
  def update_has_image
    if @post.update(post_params)
      # 添付ファイルが猫の画像だった場合
      flash[:success] = t('messages.post.update')
      # モデルのメソッド処理(update_tags)に入る
      @post.update_tags(@tags)
      redirect_to posts_path
    else
      flash.now[:danger] = t('messages.post.update_faild')
      render :edit, status: :unprocessable_entity
    end
  end

  # 投稿更新時、猫以外の画像を添付していた場合の処理
  def update_bad_image
    flash.now[:danger] =  t('messages.post.cat_validation')
    render :edit, status: :unprocessable_entity
  end

  # 投稿更新時、画像を添付していた場合の処理
  def update_not_image
    # 画像を添付していない場合の処理
    if @post.update(post_params)
      flash[:success] = t('messages.post.update')
      # モデルのメソッド処理(update_tags)に入る
      @post.update_tags(@tags)
      redirect_to posts_path
    else
      flash.now[:danger] = t('messages.post.update_faild')
      render :edit, status: :unprocessable_entity
    end
  end

  # タグの数チェック
  def tags_over_check
    flash.now[:danger] = t('messages.post.tag_faild')
    render :edit, status: :unprocessable_entity
  end
end
