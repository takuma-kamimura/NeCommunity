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

  def create
    @health_record = HealthRecord.new(health_record_params)
    if @health_record.save
      # flash[:success] = t('activerecord.attributes.user.New_registration_successful')
      redirect_to catrecord_health_records_path
    else
      # flash.now[:danger] = t('activerecord.attributes.user.New_registration_failed')
      render :new, status: :unprocessable_entity # renderでフラッシュメッセージを表示するときはstatus: :unprocessable_entityをつけないと動作しない。
    end
  end

  private

  def health_record_params
    params.require(:health_record).permit(:weight, :note, :cat_id)
  end
end
