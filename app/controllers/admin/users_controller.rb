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
      redirect_to admin_user_path
    else
      render :edit, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :self_introduction, :avatar, :avatar_cache, :role)
  end

end
