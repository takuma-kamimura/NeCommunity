class Admin::HealthRecordsController < Admin::BaseController

  def catrecord
    # @catrecord = current_user.cats
    # @catrecord = current_user.cats.includes(:user).order(created_at: :asc)
    # @catrecords = Cat.all
    @q = Cat.ransack(params[:q])
    @catrecords = @q.result(distinct: true).order(created_at: :desc)
  end
  
  def index
    # @health_records = HealthRecord.all
    @health_records = HealthRecord.includes(:cat).where(cat_id: params[:cat_id]).order(created_at: :asc)
  end

  def edit
    @health_record = HealthRecord.find(params[:id])
  end

  def show
    @health_record = HealthRecord.find(params[:id])
  end

  def update
    @health_record = HealthRecord.find(params[:id])
    @health_record.update!(health_record_params)
    redirect_to admin_health_record_path(@health_record)
  end

  def destroy
    @health_record = HealthRecord.find(params[:id])
    @cat = @health_record.cat
    @health_record.destroy!
    redirect_to admin_health_records_path(cat_id: @cat.id)
  end

  private

  def health_record_params
    params.require(:health_record).permit(:weight, :note)
  end
end
