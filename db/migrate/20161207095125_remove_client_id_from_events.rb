class RemoveClientIdFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :client_id, :integer
  end
end
