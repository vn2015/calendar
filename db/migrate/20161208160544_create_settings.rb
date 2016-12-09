class CreateSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :settings do |t|
      t.integer :buffer_time
      t.string :email_report

      t.timestamps
    end
  end
end
