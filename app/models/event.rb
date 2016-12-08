class Event < ApplicationRecord
  belongs_to :program
  belongs_to :meetingtype
  has_many :user_events
  has_many :users, :through => :user_events

  before_save :calculate_hours

  validates :title, presence: true
  validates :program_id, presence: true
  validates :launch_break, presence: true

  private
  def calculate_hours
    total_hours =((self.end.to_time - self.start.to_time - self.launch_break.minutes)/3600).round(2)
    self.event_hours = total_hours
  end
end
