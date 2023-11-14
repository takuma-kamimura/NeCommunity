class HealthRecordsController < ApplicationController
  def index
    @health_records = HealthRecord.includes(:cat).where(cat_id: params[:cat_id]).order(created_at: :asc)
    # @cat_name = Cat.find_by(id: params[:cat_id]).name
    @cat = Cat.find_by(id: params[:cat_id])
  end

  def catrecord
    # @catrecord = current_user.cats
    @catrecord = current_user.cats.includes(:user).order(created_at: :asc)
  end

  def show
    @health_record = HealthRecord.find(params[:id])
  end

  def new
    @health_record = HealthRecord.new
  end

  def edit
    @health_record = HealthRecord.find(params[:id])
    @cat = @health_record.cat
  end

  def create
    @health_record = HealthRecord.new(health_record_params)
    if @health_record.save
      # flash[:success] = t('activerecord.attributes.user.New_registration_successful')
      @cat = @health_record.cat

      redirect_to health_records_path(cat_id: @health_record.cat.id)
    else
      # flash.now[:danger] = t('activerecord.attributes.user.New_registration_failed')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  def update
    return unless set_health_record.user_id == current_user.id

    @health_record = HealthRecord.find_by(id: params[:id])
    if @health_record.update(health_record_params)
      # flash[:success] = t('board.board_update')
      
      @cat = @health_record.cat
      redirect_to health_records_path(cat_id: @health_record.cat.id)
    else
      @cat = cat_params
      # flash[:danger] = t('board.board_update_failed')
      redirect_to edit_health_records_path(@health_record), status: :see_other # 削除処理の時、「status: :see_other」をつけないと上手く機能しない。
    end
  end


  private

  def set_health_record
    @health_record = HealthRecord.find(params[:id])
    @user = @health_record.cat
  end

  def health_record_params
    params.require(:health_record).permit(:weight, :note, :cat_id)
  end
end
