class Admin::BaseController < ApplicationController
    before_action :check_admin
    layout 'admin/layouts/application'


  def not_authenticated
    redirect_to admin_login_path, warning: t('defaults.message.require_login')
    # ログインしていない場合は自動的にnot_authenticaedというメソッドを実行。
  end

    # check_admin処理でログインしたcurrent_userがadminかを判定している。
  def check_admin
    # current_userが「admin」かチェックしている。adminの場合は「return if」により処理がパズされる。adminじゃない場合は下の処理が作動する。
    return if current_user.admin?

    flash[:danger] = t('user_sessions.management.login_failed')
    redirect_to root_path
  end
end
