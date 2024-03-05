class CatsController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  def index
    @cats = current_user.cats.includes(:user).order(created_at: :asc)
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    if cat_params[:avatar].present?
      result = Vision.image_analysis(cat_params[:avatar])
      if result
        create_has_image # 添付画像が猫の画像だった場合の処理
      else
        create_bad_image # 添付画像が猫の画像以外の場合の処理
      end
    else
      create_not_image # 画像を添付していない場合の処理
    end
  end

  def update
    return unless set_cat.user_id == current_user.id

    if cat_params[:avatar].present?
      result = Vision.image_analysis(cat_params[:avatar])
      if result
        update_has_image # 添付画像が猫の画像だった場合の処理
      else
        update_bad_image # 添付画像が猫の画像以外の場合の処理
      end
    else
      update_not_image # 画像を添付していない場合の処理
    end
  end

  def destroy
    return unless set_cat.user_id == current_user.id

    @cat = Cat.find_by(id: params[:id])
    @cat.destroy!
    flash[:success] = t('messages.cats.delete')
    redirect_to cats_path, status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
  end

  private

  def set_cat
    @cat = current_user.cats.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:name, :birthday, :self_introduction, :gender,
                                :avatar, :avatar_cache, :cat_breed_id, :remove_cat_avatar).merge(user_id: current_user.id)
  end

  # 新規猫プロフィール作成時、猫の画像を添付していた場合の処理
  def create_has_image
    if @cat.save
      flash[:success] = t('messages.cats.create')
      redirect_to cats_path
    else
      flash.now[:danger] = t('messages.cats.create_faild')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  # 新規猫プロフィール作成時、猫以外の画像を添付していた場合の処理
  def create_bad_image
    @cat.avatar = nil # renderで戻る前に画像をnillにする処理
    flash.now[:danger] = t('messages.cats.cat_validation')
    render :new, status: :unprocessable_entity
  end

  # 新規猫プロフィール作成時、画像を添付していない場合の処理
  def create_not_image
    # 画像を添付していない場合の処理
    if @cat.save
      flash[:success] = t('messages.cats.create')
      redirect_to cats_path
    else
      flash.now[:danger] = t('messages.cats.create_faild')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  # 猫プロフィール更新時、猫の画像を添付していた場合の処理
  def update_has_image
    @cat = Cat.find_by(id: params[:id])
    unless @cat.update(cat_params)
      flash.now[:danger] = t('messages.cats.update_faild')
      render turbo_stream: turbo_stream.replace(
        "flash-messages-container-edit-#{@cat.id}",
        partial: 'shared/flash_message',
        locals: { message: t('messages.cats.update_faild'), css_class: 'danger' }
      )
    end
  end

  # 猫プロフィール更新時、猫以外の画像を添付していた場合の処理
  def update_bad_image
    # 添付ファイルが猫とは関係ない画像だった場合
    flash.now[:danger] = t('messages.cats.cat_validation')
    render turbo_stream: turbo_stream.replace(
      "flash-messages-container-edit-#{@cat.id}",
      partial: 'shared/flash_message',
      locals: { message: t('messages.cats.cat_validation'), css_class: 'danger' }
    )
  end

  # 猫プロフィール更新時、画像を添付していなかった場合の処理
  def update_not_image
    # 画像を添付していない場合の処理
    @cat = Cat.find_by(id: params[:id])
    unless @cat.update(cat_params)
      flash.now[:danger] = t('messages.cats.update_faild')
      # エラー時の Turbo Stream
      render turbo_stream: turbo_stream.replace(
        "flash-messages-container-edit-#{@cat.id}",
        partial: 'shared/flash_message',
        locals: { message: t('messages.cats.update_faild'),
                  css_class: 'danger' }
      ), status: :unprocessable_entity
    end
  end
end
