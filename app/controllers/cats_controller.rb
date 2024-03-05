class CatsController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  def index
    # @cats = current_user.cats.order(created_at: :asc) # 生成した順番に取得する
    @cats = current_user.cats.includes(:user).order(created_at: :asc)
  end

  def new
    @cat = Cat.new
  end

  # def show
  #   @cat = Cat.find(params[:id])
  # end

  # def edit
  #   return unless set_cat.user_id == current_user.id

  #   @cat = Cat.find(params[:id])
  # end

  def create
    @cat = Cat.new(cat_params)
    if cat_params[:avatar].present?
      result = Vision.image_analysis(cat_params[:avatar])
      # 画像を添付した場合の処理
      if result
        if @cat.save
          # 添付ファイルが猫の画像だった場合
          flash[:success] = t('messages.cats.create')
          redirect_to cats_path
        else
          flash.now[:danger] = t('messages.cats.create_faild')
          render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
        end
      else
        # 添付ファイルが猫とは関係ない画像だった場合
        @cat.avatar = nil # renderで戻る前に画像をnillにする処理
        flash.now[:danger] = t('messages.cats.cat_validation')
        render :new, status: :unprocessable_entity
      end
    else
      # 画像を添付していない場合の処理
      if @cat.save
        flash[:success] = t('messages.cats.create')
        redirect_to cats_path
      else
        flash.now[:danger] = t('messages.cats.create_faild')
        render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
      end
    end
  end

  def update
    return unless set_cat.user_id == current_user.id

    if cat_params[:avatar].present?
      result = Vision.image_analysis(cat_params[:avatar])
      # 画像を添付した場合の処理
      if result
        @cat = Cat.find_by(id: params[:id])
        if @cat.update(cat_params)
          # 添付ファイルが猫の画像だった場合
          # flash.now[:success] = t('messages.cats.update')
          # redirect_to cats_path
        else
          flash.now[:danger] = t('messages.cats.update_faild')
          # render :edit, status: :unprocessable_entity
          render turbo_stream: turbo_stream.replace("flash-messages-container-edit-#{@cat.id}", partial: 'shared/flash_message', locals: { message: t('messages.cats.update_faild'), css_class: 'danger' })
        end
      else
        # 添付ファイルが猫とは関係ない画像だった場合
        flash.now[:danger] = t('messages.cats.cat_validation')
        # render :edit, status: :unprocessable_entity
        # render json: { success: false, message: flash.now[:danger] }, status: :unprocessable_entity
        render turbo_stream: turbo_stream.replace("flash-messages-container-edit-#{@cat.id}", partial: 'shared/flash_message', locals: { message: t('messages.cats.cat_validation'), css_class: 'danger' })
      end
    else
      # 画像を添付していない場合の処理
      @cat = Cat.find_by(id: params[:id])
      if @cat.update(cat_params)
        # flash.now[:success] = t('messages.cats.update')
        # redirect_to cats_path
      else
        flash.now[:danger] = t('messages.cats.update_faild')
        # render json: { success: false, message: flash.now[:danger] }, status: :unprocessable_entity
        # エラー時の Turbo Stream
        # render turbo_stream: turbo_stream.replace("flash-messages-container-edit-#{@cat.id}", partial: 'shared/flash_message', locals: { message: t('messages.cats.update_faild'), css_class: 'danger' })
        render turbo_stream: turbo_stream.replace("flash-messages-container-edit-#{@cat.id}", partial: 'shared/flash_message', locals: { message: t('messages.cats.update_faild'), css_class: 'danger' }), status: :unprocessable_entity
      end
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
    params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache, :cat_breed_id, :remove_cat_avatar).merge(user_id: current_user.id)
  end

end
