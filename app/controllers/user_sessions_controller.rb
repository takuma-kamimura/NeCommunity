class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def new; end

  
  def create
    @user = login(params[:email], params[:password])
    if @user
      # flash[:success] = t('user_sessions.new.logged_in') # ログアウトが成功したことを確認してからflashメッセージを入れる。
      flash[:success] = t('messages.users.logged_in') # 'ログインに成功しました。'
      redirect_to root_path
    else
      flash[:danger] = t('messages.users.login_faild')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:els] = t('messages.users.logout')
    redirect_to root_path
  end
end
