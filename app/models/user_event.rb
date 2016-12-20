class UserEvent < ApplicationRecord
  belongs_to :user
  belongs_to :event

  before_update :set_fields

  private

  def set_fields

    if self.is_confirmed ==true
        program_is_paid = Event.find(self.event_id).program[:is_paid]
        event_hours = Event.find(self.event_id)[:event_hours]
        user_hourly_rate = User.find(self.user_id)[:hourly_rate]
        earnings = 0

        if program_is_paid == 1
          earnings = event_hours * user_hourly_rate
        end

        self.earnings = earnings
        self.hours = event_hours
        self.hourly_rate = user_hourly_rate
        self.is_paid = program_is_paid
    end
  end
end
