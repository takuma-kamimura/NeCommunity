class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login# この一文を追加しないと一回ログインしないと管理画面のログイン画面に入れない。
  skip_before_action :check_admin, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      # flash[:success] = t('user_sessions.new.logged_in') # ログアウトが成功したことを確認してからflashメッセージを入れる。
      binding.pry
      redirect_to admin_root_path
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
