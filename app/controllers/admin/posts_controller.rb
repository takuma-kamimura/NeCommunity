class Admin::PostsController < Admin::BaseController

  def index
    # @posts = Post.all

    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update!(post_params)
    redirect_to admin_post_path(@post)
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy!
    # flash[:success] = t('board.board_deleted')
    redirect_to admin_posts_path, status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
  end

  private

  def post_params
    # params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache).merge(user_id: current_user.id, cat_breed_id: params[:cat_breed_id])
    params.require(:post).permit(:title, :body, :photo, :photo_cache, :cat_id)
  end

end
