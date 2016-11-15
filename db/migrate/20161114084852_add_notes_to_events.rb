class AddNotesToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :notes, :text
  end
end
