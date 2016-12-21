class CreateProgramStatusHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :program_status_histories do |t|
      t.references :program, foreign_key: true
      t.boolean :old
      t.boolean :new

      t.timestamps
    end
  end
end
