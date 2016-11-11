class Event < ApplicationRecord
  belongs_to :client
  belongs_to :program

  validates :title, presence: true
  validates :client_id, presence: true
  validates :program_id, presence: true
end
