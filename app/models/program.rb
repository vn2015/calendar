class Program < ApplicationRecord
  has_many :events, :dependent => :delete_all
  validates :name, presence: true
end
