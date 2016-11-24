class AddColorToProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :color, :string
  end
end
