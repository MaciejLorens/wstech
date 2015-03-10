class Wz < ActiveRecord::Base
  has_many :orders
  has_many :metal_orders, -> () { where type: 'MetalOrder' }, class_name: 'Order'
  has_many :furniture_orders, -> () { where type: 'FurnitureOrder' }, class_name: 'Order'

  validates_presence_of :number

  scope :at_date, ->(date) {Wz.where('created_at >= ? AND created_at < ?', date.beginning_of_day, date.beginning_of_day + 1.day)}

  after_create :set_number

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ['Id', 'Opis', 'Zamawiający', 'Data zlecenia', 'Na kiedy ma być', 'Ilość', 'Cena', 'Potwierdzenie daty zlecenia', 'Fakturowano dnia', 'Data realizacji', 'Numer WZ']
      orders.each do |order|
        csv << [order.number, order.description, "#{order.user.first_name} #{order.user.last_name}", date(order.created_at), date(order.delivery_request_date), order.quantity, order.price, date(order.confirmation_date), date(order.invoice_date), date(order.delivery_date), order.try(:wz).try(:number)]
      end
    end
  end

  private

  def set_number
    time = Time.now
    self.update_column(:number, "WZ/#{time.strftime('%y')}/#{time.month}/#{time.day}/#{self.id}")
  end

  def date(date)
    date.localtime.strftime('%d-%m-%Y') if date.present?
  end
end
