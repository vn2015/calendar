class AddIsConfirmedToUserEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :is_confirmed, :boolean, :default=>false
  end
end
