class ResourcesController < ApplicationController
  before_action :set_resource, only: [:destroy]
  before_action :set_order, only: [:create, :destroy]

  def create
    @resource = @order.resources.new(resource_params)

    if @resource.save
      redirect_to controller: controller_name(@order), action: :edit, id: @order.id
    else
      render :new
    end
  end

  def destroy
    @resource.destroy
    redirect_to controller: controller_name(@order), action: :edit, id: @order.id
  end

  private

  def controller_name(order)
    if order.type == 'FurnitureOrder'
      'furniture_orders'
    else
      'metal_orders'
    end
  end

  def set_resource
    @resource = Resource.find(params[:id])
  end

  def set_order
    order_id = params[:furniture_order_id] || params[:metal_order_id]
    @order = Order.find(order_id)
  end

  def resource_params
    params.require(:resource).permit!
  end
end
