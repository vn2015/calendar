class AddIndexesToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :date_start, :date
    add_index :events, :date_start
    add_column :events, :date_end, :date
    add_index :events, :date_end
  end
end
