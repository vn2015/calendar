class Client < ApplicationRecord
  validates :name, presence: true
  validates :dob, presence: true
end
