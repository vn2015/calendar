class AddEventHoursToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :event_hours, :decimal, :default => 0, :precision => 10, :scale => 2
  end
end
