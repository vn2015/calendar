class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.date :dob, null: false
      t.text :notes

      t.timestamps
    end
  end
end
