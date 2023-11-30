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
    if @tag.update(tag_params)
      flash[:success] = t('admin.messages.update')
      redirect_to admin_tag_path(@tag)
    else
      flash.now[:danger] = t('admin.messages.update_faild')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy!
    flash[:success] = t('admin.messages.delete')
    redirect_to admin_tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
