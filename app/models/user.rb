class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :set_user_name

  validates :username, presence: true
  validates :email_report, presence: true
  validates :buffer_time, presence: true

  private
  def set_user_name
    self.username ="#{self.first_name} #{self.last_name}"
  end
end
