class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login # この一文を追加しないと一回ログインしないと管理画面のログイン画面に入れない。
  skip_before_action :check_admin, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to admin_root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to admin_root_path
  end
end
