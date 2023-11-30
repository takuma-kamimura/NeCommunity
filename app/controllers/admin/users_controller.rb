class Admin::UsersController < Admin::BaseController

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t('admin.messages.update')
      redirect_to admin_user_path
    else
      flash.now[:danger] = t('admin.messages.update_faild')
      render :edit, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    flash[:success] = t('admin.messages.delete')
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :self_introduction, :avatar, :avatar_cache, :role, :remove_avatar)
  end

end
