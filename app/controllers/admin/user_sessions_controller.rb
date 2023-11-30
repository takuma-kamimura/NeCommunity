class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login # この一文を追加しないと一回ログインしないと管理画面のログイン画面に入れない。
  skip_before_action :check_admin, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:success] = t('messages.users.logged_in')
      redirect_to admin_root_path
    else
      flash[:danger] = t('messages.users.login_faild')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:els] = t('messages.users.logout')
    redirect_to admin_root_path
  end
end
