class CreateUserEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :user_events do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true

      t.decimal :hours, :default => 0, :precision => 12, :scale => 2
      t.decimal :earnings, :default => 0, :precision => 12, :scale => 2
      t.timestamps
    end
  end
end
