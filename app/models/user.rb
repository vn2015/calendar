class User < ApplicationRecord
  has_many :user_event
  has_many :event , :through => :user_event


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :set_user_name

  validates :first_name, presence: true
  validates :last_name, presence: true

  private
  def set_user_name
    self.username ="#{self.first_name} #{self.last_name}"
  end
end
