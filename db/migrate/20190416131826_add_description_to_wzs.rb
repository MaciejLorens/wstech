class AddDescriptionToWzs < ActiveRecord::Migration
  def change
    add_column :wzs, :description, :string
  end
end
