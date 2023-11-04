class UserSessionsController < ApplicationController
  def new; end

  
  def create
    @user = login(params[:email], params[:password])
    if @user
      # flash[:success] = t('user_sessions.new.logged_in') # ログアウトが成功したことを確認してからflashメッセージを入れる。
      redirect_to root_path
    else
      # flash[:danger] = t('user_sessions.new.login_failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end