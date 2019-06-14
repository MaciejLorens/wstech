class HomeController < ApplicationController

  def index
    from = (params[:from] || Time.now.beginning_of_year.to_s).to_date
    to = (params[:to] || Time.now.end_of_day.to_s).to_date

    if params[:from].present? && params[:to].present?
      @orders = Order.where(status: 'delivered').from_to(from, to)
    else
      @orders = Order.where(status: 'delivered').all
    end
  end

  def search
    @orders = Order.where('lower(description) LIKE ?', "%#{params[:query].downcase}%").includes(:resources, :user, :wzs).order(created_at: :desc)
    render json: {content: render_to_string(partial: 'search')}
  end

end
