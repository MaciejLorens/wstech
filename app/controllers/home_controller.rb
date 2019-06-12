class HomeController < ApplicationController

  def index
    from = params[:from] || 1.month.ago.beginning_of_day
    to = params[:to] || Time.now.end_of_day

    @metal_orders = Order.metal.where('delivery_date >= ? AND delivery_date <= ?', from, to)
    @furniture_orders = Order.furniture.where('delivery_date >= ? AND delivery_date <= ?', from, to)
    @orders = Order.where('delivery_date >= ? AND delivery_date <= ?', from, to)
  end

  def search
    @orders = Order.where('lower(description) LIKE ?', "%#{params[:query].downcase}%").includes(:resources, :user, :wzs).order(created_at: :desc)
    render json: {content: render_to_string(partial: 'search')}
  end

end
