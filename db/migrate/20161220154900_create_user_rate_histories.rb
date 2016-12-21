class CreateUserRateHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :user_rate_histories do |t|
      t.references :user, foreign_key: true
      t.decimal :old, :precision => 12, :scale => 2
      t.decimal :new, :precision => 12, :scale => 2

      t.timestamps
    end
  end
end
