class AddColumnLunchBreakToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :launch_break, :integer, :default => 0
  end
end
