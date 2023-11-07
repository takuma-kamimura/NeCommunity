class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def show 
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # flash[:success] = t('profiles.update')
      redirect_to profile_path
    else
      # flash[:danger] = t('profiles.update_failed')
      render :edit, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :self_introduction, :avatar, :avatar_cache)
  end

end
