class AddMeetingTypeIdToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :meetingtype, foreign_key: true
  end
end
