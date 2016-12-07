class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :date
    add_column :users, :hours, :decimal, :default => 0, :precision => 12, :scale => 2
    add_column :users, :hourly_rate, :decimal, :default => 0, :precision => 10, :scale => 2
    add_column :users, :earnings, :decimal, :default => 0, :precision => 12, :scale => 2
  end
end
