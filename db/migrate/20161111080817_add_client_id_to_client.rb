class AddClientIdToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :client_id, :string
  end
end
