class WzsController < ApplicationController
  before_filter :authentication, except: [:index, :show]

  def new
    @orders = Order
                .includes(:resources, :user, :orders_wzs, :wzs)
                .where(status: 'delivered', full_in_wz: false)
                .order('orders.created_at DESC')
  end

  def index
    @from = params[:from] || 1.month.ago.strftime('%d-%m-%Y')
    @to = params[:to] || 0.month.ago.strftime('%d-%m-%Y')

    @wzs = Wz.where('status IS NULL')
             .from_to(@from, @to)
             .includes(orders: [:user, :resources])
             .order(created_at: :desc)
  end

  def show
    @wz = Wz.find(params[:id])
  end

  def create
    wz = Wz.create(number: 'sample')

    params[:orders].map(&:last).each do |id, quantity_in_wz|
      order = Order.find(id)
      orders_wz = order.orders_wzs.find_or_create_by(wz_id: wz.id)
      orders_wz.update(quantity: orders_wz.quantity + quantity_in_wz.to_i)
      order.update(quantity_in_wz: quantity_in_wz.to_i + order.quantity_in_wz)
      order.update(full_in_wz: true) if order.quantity_in_wz == order.quantity
    end

    render json: {}, status: 201
  end

  def update
    @wz = Wz.find(params[:id])
    @wz.update(description: params[:description])

    render json: {}, status: 200
  end

  def destroy
    wz = Wz.find(params[:id])

    wz.orders_wzs.each do |orders_wz|
      order = orders_wz.order
      order.update(quantity_in_wz: order.quantity_in_wz - orders_wz.quantity)
      order.update(full_in_wz: false) if order.quantity_in_wz != order.quantity
      orders_wz.destroy
    end

    wz.update(status: 'deleted')

    redirect_to action: :index, notice: 'WZ została usunięta.'
  end

  def deleted
    @wzs = Wz.where('status IS ?', 'deleted').includes(orders: [:user]).order(created_at: :desc)
  end

  private

  def wz_params
    params.require(:wz).permit!
  end

  def authentication
    redirect_to :root unless current_user.admin?
  end

end
