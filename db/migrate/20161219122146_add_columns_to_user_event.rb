class AddColumnsToUserEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :is_paid, :smallint, :default => 0
  end
end
