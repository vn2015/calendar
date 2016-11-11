class AddHoursToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :hours, :decimal, :default => 0
  end
end
