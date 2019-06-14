class MetalOrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :history]

  def inquiry
    @metal_order = Order.metal.where(status: 'inquiry').order(created_at: :desc)
  end

  def proposition
    @metal_order = Order.metal.where(status: 'proposition').order(created_at: :desc)
  end

  def not_confirmed
    @metal_order = Order.metal.where(status: 'not_confirmed').order(created_at: :desc)
  end

  def ordered
    @metal_order = Order.metal.where(status: 'ordered').order(created_at: :desc)
  end

  def delivered_without_wz
    @metal_order = Order.metal
                     .includes(:resources, :user, :wzs)
                     .where(status: 'delivered', full_in_wz: false)
                     .order(created_at: :desc)
  end

  def delivered_with_wz
    @metal_order = Order.metal
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
    @metal_order = MetalOrder.new(user_id: current_user.id)
  end

  def new_inquiry
    @metal_order = MetalOrder.new(user_id: current_user.id, status: 'inquiry')
    render :new
  end

  def edit
  end

  def create
    @metal_order = MetalOrder.new(metal_order_params.merge(user_id: current_user.id))

    if @metal_order.save
      resources_params.each do |resource|
        @metal_order.resources.create(resource) if resource['image'].present? || resource['link'].present?
      end
      redirect_to '/', notice: 'Zamówienie zostało stworzone.'
    else
      render :new
    end
  end

  def update
    if @metal_order.update(metal_order_params)
      redirect_to params[:referer], notice: 'Zamówienie zostało zaktualizowane.'
    else
      render :edit
    end
  end

  def destroy
    status = @metal_order.status.to_sym
    if status == :delivered
      status = @metal_order.full_in_wz? ? :delivered_with_wz : :delivered_without_wz
    end
    @metal_order.update(status: 'deleted', deleted_at: Time.now, deleted_by: "#{current_user.first_name} #{current_user.last_name}")

    if status == :delivered_with_wz
      redirect_to params[:referer]
    else
      redirect_to action: status
    end
  end

  def download
    status = params[:status]

    respond_to do |format|
      format.csv do
        csv = MetalOrder.to_csv(status)
        send_data csv, filename: "orders-#{status}-#{Date.today}.csv"
      end
    end
  end

  def deleted
    @metal_order = Order.metal.where(status: 'deleted').order(created_at: :desc)
  end

  private

  def set_order
    @metal_order = Order.metal.find(params[:id])
  end

  def metal_order_params
    params.require(:metal_order).permit!.except(:image1, :image2, :image3, :url1, :url2, :url3)
  end

  def resources_params
    [params[:metal_order][:image1], params[:metal_order][:image2], params[:metal_order][:image3], params[:metal_order][:url1], params[:metal_order][:url2], params[:metal_order][:url3]].compact
  end
end
