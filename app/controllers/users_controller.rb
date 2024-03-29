class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create usercat ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      flash[:success] = t('messages.users.new')
      redirect_to posts_path
    else
      flash.now[:danger] = t('messages.users.new_faild')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  # 他ユーザーの猫一覧
  def usercat
    @user = User.find(params[:user_id])
    @usercats = @user.cats.includes(:user).order(created_at: :asc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
