class DeleteAddColumnFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :finished, :boolean
    add_column :orders, :driver_finished, :boolean
    add_column :orders, :student_finished, :boolean
  end
end
