class AddColumnApprovalToProgram < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :approval, :boolean, :default=>false
  end
end
