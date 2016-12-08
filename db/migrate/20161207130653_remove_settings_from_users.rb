class RemoveSettingsFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :email_report, :string
    remove_column :users, :buffer_time, :string
  end
end
