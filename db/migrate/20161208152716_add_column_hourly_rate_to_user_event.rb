class AddColumnHourlyRateToUserEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :user_events, :hourly_rate, :decimal, :default => 0, :precision => 12, :scale => 2
  end
end
