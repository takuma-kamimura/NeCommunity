class Admin::PostsController < Admin::BaseController

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy!
    # flash[:success] = t('board.board_deleted')
    redirect_to admin_posts_path, status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
  end
end
