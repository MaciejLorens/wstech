class AddExpenseToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expense, :float
  end
end
