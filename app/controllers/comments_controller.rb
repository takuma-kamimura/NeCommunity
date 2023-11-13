class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.save
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    # params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache).merge(user_id: current_user.id, cat_breed_id: params[:cat_breed_id])
    params.require(:comment).permit(:body).merge(user_id: current_user.id, post_id: params[:post_id])
  end
end
