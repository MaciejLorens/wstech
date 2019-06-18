class AddPurchaserToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :purchaser, :string
  end
end
