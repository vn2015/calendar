class AddEmailReportBuffeTimeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_report, :string
    add_column :users, :buffer_time, :integer
  end
end
