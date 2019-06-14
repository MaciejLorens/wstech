class MetalOrder < Order

  after_create :set_number

  def self.to_csv(status)
    @metal_orders = Order.metal.where(status: status).order(created_at: :asc)

    CSV.generate do |csv|
      csv << ['Numer', 'Opis', 'Zamawiający', 'Data zlecenia', 'Na kiedy ma być', 'Ilość', 'Cena', 'Potwierdzenie daty zlecenia', 'Data realizacji', 'Numer WZ']
      @metal_orders.each do |order|
        csv << [order.number, order.description, "#{order.user.first_name} #{order.user.last_name}", date(order.created_at), date(order.delivery_request_date), order.quantity, order.price, date(order.confirmation_date), date(order.delivery_date), order.try(:wz).try(:number)]
      end
    end
  end

  private

  def set_number
    time = Time.now
    self.update_column(:number, "ZM/#{time.strftime('%y')}/#{time.month}/#{time.day}/#{self.id}")
  end

  def self.date(date)
    date.localtime.strftime('%d-%m-%Y') if date.present?
  end
end
