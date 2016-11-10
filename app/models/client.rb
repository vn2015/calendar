class Client < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
end
