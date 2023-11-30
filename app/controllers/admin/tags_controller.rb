class Admin::TagsController < Admin::BaseController
  def index
    @q = Tag.ransack(params[:q])
    @tags = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag.update!(tag_params)
    redirect_to admin_tag_path(@tag)
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy!
    redirect_to admin_tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
