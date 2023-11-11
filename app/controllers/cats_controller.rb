class CatsController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  def index
    @cats = current_user.cats.order(created_at: :asc) # 生成した順番に取得する
  end

  def new
    @cat = Cat.new
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def edit
    return unless set_cat.user_id == current_user.id

    @cat = Cat.find(params[:id])
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      # flash[:success] = t('activerecord.attributes.user.New_registration_successful')
      redirect_to cats_path
    else
      flash.now[:danger] = t('activerecord.attributes.user.New_registration_failed')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  def update
    return unless set_cat.user_id == current_user.id

    @cat = Cat.find_by(id: params[:id])
    if @cat.update(cat_params)
      # flash[:success] = t('board.board_update')
      redirect_to cats_path
    else
      @cat = cat_params
      # flash[:danger] = t('board.board_update_failed')
      redirect_to edit_cat_path(@cat), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
    end
  end

  def destroy
    return unless set_cat.user_id == current_user.id

    @cat = Cat.find_by(id: params[:id])
    @cat.destroy!
    # flash[:success] = t('board.board_deleted')
    redirect_to cats_path, status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
  end

  private

  def set_cat
    @cat = current_user.cats.find(params[:id])
  end

  def cat_params
    # params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache).merge(user_id: current_user.id, cat_breed_id: params[:cat_breed_id])
    params.require(:cat).permit(:name, :birthday, :self_introduction, :gender, :avatar, :avatar_cache, :cat_breed_id).merge(user_id: current_user.id)
  end

end
