class DropClientsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :clients do |t|
      t.string :name, null: false
      t.date :dob, null: false
      t.text :notes
      t.timestamps
      t.string :client_id
      t.decimal :hours, :default => 0, :precision => 10, :scale => 2
    end
  end
end
