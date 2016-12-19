class AddDateConfirmedToUserEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :date_confirmed, :datetime
  end
end
