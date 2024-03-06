class UsersController < ApplicationController
  # before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :require_login, only: %i[new create show usercat ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('messages.users.new')
      Rails.logger.error("User registration failed. Errors: #{@user.errors.full_messages}")
      redirect_to root_path
    else
      flash.now[:danger] = t('messages.users.new_faild')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  def show
    @user = User.find(params[:id])
  end

  # 他ユーザーの猫一覧
  def usercat
    @user = User.find(params[:user_id])
    # @usercats = @user.cats
    @usercats = @user.cats.includes(:user).order(created_at: :asc)
  end

  private

  # def set_user
  #   @user = User.find(params[:id])
  # end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
