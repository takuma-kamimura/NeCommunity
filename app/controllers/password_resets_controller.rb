class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    # ↓「存在しないメールアドレスです」という旨の文言を表示すると、逆に存在するメールアドレスを特定されてしまうため
    # ↓あえて成功時のメッセージを送信させている
    flash[:success] = t('messages.users.reset_password_mail')
    redirect_to root_path
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]
    if params[:user][:password].present?
      @user.change_password(params[:user][:password])
      flash[:success] = t('messages.users.reset_password_success')
      redirect_to login_path
    else
      flash.now[:danger] = t('messages.users.reset_password_faild')
      render :edit, status: :unprocessable_entity
    end
  end
end
