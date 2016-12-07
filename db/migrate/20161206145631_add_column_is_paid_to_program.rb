class AddColumnIsPaidToProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :is_paid, :integer
  end
end
