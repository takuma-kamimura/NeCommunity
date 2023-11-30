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
      # redirect_to edit_cat_path(@cat), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
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
    params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache, :cat_breed_id, :user_id)
  end
end
