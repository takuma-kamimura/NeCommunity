class Admin::CatsController < Admin::BaseController
  def index
    @q = Cat.ransack(params[:q])
    @cats = @q.result(distinct: true).order(created_at: :desc)
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find_by(id: params[:id])
    if @cat.update(cat_params)
      flash[:success] = t('admin.messages.update')
      redirect_to admin_cats_path
    else
      flash.now[:danger] = t('admin.messages.update_faild')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy!
    flash[:success] = t('admin.messages.delete')
    redirect_to admin_cats_path
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache, :cat_breed_id, :user_id, :remove_cat_avatar)
  end
end
