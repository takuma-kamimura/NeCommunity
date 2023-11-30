class Admin::HealthRecordsController < Admin::BaseController
  def catrecord
    @q = Cat.ransack(params[:q])
    @catrecords = @q.result(distinct: true).order(created_at: :desc)
  end

  def index
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
    if @health_record.update(health_record_params)
      flash[:success] = t('admin.messages.update')
      redirect_to admin_health_record_path(@health_record)
    else
      flash.now[:danger] = t('admin.messages.update_faild')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @health_record = HealthRecord.find(params[:id])
    @cat = @health_record.cat
    @health_record.destroy!
    flash[:success] = t('admin.messages.delete')
    redirect_to admin_health_records_path(cat_id: @cat.id)
  end

  private

  def health_record_params
    params.require(:health_record).permit(:weight, :note)
  end
end
