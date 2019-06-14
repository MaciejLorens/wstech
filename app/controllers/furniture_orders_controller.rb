class FurnitureOrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :history]

  def inquiry
    @furniture_order = Order.furniture.where(status: 'inquiry').order(created_at: :desc)
  end

  def proposition
    @furniture_order = Order.furniture.where(status: 'proposition').order(created_at: :desc)
  end

  def not_confirmed
    @furniture_order = Order.furniture.where(status: 'not_confirmed').order(created_at: :desc)
  end

  def ordered
    @furniture_order = Order.furniture.where(status: 'ordered').order(created_at: :desc)
  end

  def delivered_without_wz
    @furniture_order = Order.furniture
                         .includes(:resources, :user, :wzs)
                         .where(status: 'delivered', full_in_wz: false)
                         .order(created_at: :desc)
  end

  def delivered_with_wz
    @furniture_order = Order.furniture
                         .includes(:resources, :user, :wzs)
                         .where(status: 'delivered', full_in_wz: true)
                         .from_to(params[:from], params[:to])
                         .order(created_at: :desc)
  end

  def history
  end

  def show
  end

  def new
    @furniture_order = FurnitureOrder.new(user_id: current_user.id)
  end

  def new_inquiry
    @furniture_order = FurnitureOrder.new(user_id: current_user.id, status: 'inquiry')
    render :new
  end

  def edit
  end

  def create
    @furniture_order = FurnitureOrder.new(furniture_order_params.merge(user_id: current_user.id))

    if @furniture_order.save
      resources_params.each do |resource|
        @furniture_order.resources.create(resource) if resource['image'].present? || resource['link'].present?
      end
      redirect_to '/', notice: 'Zamówienie zostało stworzone.'
    else
      render :new
    end
  end

  def update
    if @furniture_order.update(furniture_order_params)
      redirect_to params[:referer], notice: 'Zamówienie zostało zaktualizowane.'
    else
      render :edit
    end
  end

  def destroy
    status = @furniture_order.status.to_sym
    if status == :delivered
      status = @furniture_order.full_in_wz? ? :delivered_with_wz : :delivered_without_wz
    end
    @furniture_order.update(status: 'deleted', deleted_at: Time.now, deleted_by: "#{current_user.first_name} #{current_user.last_name}")

    if status == :delivered_with_wz
      redirect_to params[:referer]
    else
      redirect_to action: status
    end
  end

  def download
    respond_to do |format|
      format.csv { send_data Order.furniture.to_csv(params[:status]) }
    end
  end

  def deleted
    @furniture_order = Order.furniture.where(status: 'deleted').order(created_at: :desc)
  end

  private

  def set_order
    @furniture_order = Order.furniture.find(params[:id])
  end

  def furniture_order_params
    params.require(:furniture_order).permit!.except(:image1, :image2, :image3, :url1, :url2, :url3)
  end

  def resources_params
    [params[:furniture_order][:image1], params[:furniture_order][:image2], params[:furniture_order][:image3], params[:furniture_order][:url1], params[:furniture_order][:url2], params[:furniture_order][:url3]].compact
  end
end
