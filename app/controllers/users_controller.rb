class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :require_login, only: %i[new create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
   # binding.pry
    if @user.save
      # binding.pry
      flash[:success] = t('activerecord.attributes.user.New_registration_successful')
      Rails.logger.error("User registration failed. Errors: #{@user.errors.full_messages}")
      redirect_to root_path
    else
      binding.pry
      # flash.now[:danger] = t('activerecord.attributes.user.New_registration_failed')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  private

  def user_params
    # binding.pry
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # binding.pry
  end
end
