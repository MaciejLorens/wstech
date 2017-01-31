class WzsController < ApplicationController
  before_filter :authentication, except: [:index]

  def new
    @orders = Order
                .includes(:resources, :user, :orders_wzs, :wzs)
                .where(status: 'delivered', full_in_wz: false)
                .order('orders.created_at DESC')
  end

  def index
    year = params[:year] || Date.today.year
    month = params[:month] || Date.today.month
    @wzs = Wz.at_year_at_month(year, month).includes(orders: [:user]).order(created_at: :desc)
  end

  def show
    @wz = Wz.find(params[:id])
  end

  def create
    at = DateTime.now
    wz = Wz.at_date(at).first.presence || Wz.create(created_at: at, number: 'sample')

    params[:orders].map(&:last).each do |id, quantity_in_wz|
      order = Order.find(id)
      orders_wz = order.orders_wzs.find_or_create_by(wz_id: wz.id)
      orders_wz.update(quantity: orders_wz.quantity + quantity_in_wz.to_i)
      order.update(quantity_in_wz: quantity_in_wz.to_i + order.quantity_in_wz)
      order.update(full_in_wz: true) if order.quantity_in_wz == order.quantity
    end

    render json: {}, status: 201
  end

  def destroy
    wz = Wz.find(params[:id])

    wz.orders_wzs.each do |orders_wz|
      order = orders_wz.order
      order.update(quantity_in_wz: order.quantity_in_wz - orders_wz.quantity)
      order.update(full_in_wz: false) if order.quantity_in_wz != order.quantity
      orders_wz.destroy
    end

    redirect_to action: :index, notice: 'WZ została usunięta.'
  end

  private

  def wz_params
    params.require(:wz).permit!
  end

  def authentication
    redirect_to :root unless current_user.admin?
  end
end
