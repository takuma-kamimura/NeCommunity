# 使わないコントローラー
class OauthsController < ApplicationController
  skip_before_action :require_login # applications_controllerでbefore_action :require_loginを設定している場合

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    uid = auth_params[:uid]
    if (@user = login_from(provider))
      redirect_to root_path, notice: "#{provider.titleize}でログインしました"
    else
      begin
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to root_path, notice: "#{provider.titleize}でログインしました"
      rescue StandardError
        redirect_to root_path, alert: "#{provider.titleize}でのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
      params.permit(:code, :provider, :error, :state)
  end

  def login_at(provider_name, args = {})
    redirect_to sorcery_login_url(provider_name, args), allow_other_host: true
  end
end
