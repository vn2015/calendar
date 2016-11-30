class Client < ApplicationRecord
  has_many :events,:dependent => :delete_all

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true


  def combined_value
    "#{self.first_name} #{self.last_name}"
  end

end
