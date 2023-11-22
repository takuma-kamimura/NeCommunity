class Admin::CommentsController < Admin::BaseController
  def index
    # @comments = Comment.all
    @q = Comment.ransack(params[:q])
    @comments = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update 
    @comment = Comment.find(params[:id])
    @comment.update!(comment_params)
    redirect_to admin_comment_path(@comment)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy!
    redirect_to admin_comments_path
  end

  private

  def comment_params
    # params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache).merge(user_id: current_user.id, cat_breed_id: params[:cat_breed_id])
    params.require(:comment).permit(:body) # .merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
