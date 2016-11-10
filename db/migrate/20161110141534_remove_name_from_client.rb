class RemoveNameFromClient < ActiveRecord::Migration[5.0]
  def change
    remove_column :clients, :name, :string
  end
end
