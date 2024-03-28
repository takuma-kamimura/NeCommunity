class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:success] = t('messages.users.logged_in')
      redirect_to posts_path
    else
      flash.now[:danger] = t('messages.users.login_faild')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:els] = t('messages.users.logout')
    redirect_to root_path
  end
end
