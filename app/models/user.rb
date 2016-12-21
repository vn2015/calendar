class User < ApplicationRecord
  has_many :user_event
  has_many :user_rate_histories,:dependent => :delete_all
  has_many :event , :through => :user_event


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  before_save :set_user_name
  before_update :histoty_create

  validates :first_name, presence: true
  validates :last_name, presence: true

  private
  def set_user_name
    self.username ="#{self.first_name} #{self.last_name}"
  end

  def histoty_create
    old_value = User.find(self.id).hourly_rate
    if old_value!=self.hourly_rate
      hist_obj =UserRateHistory.new
      hist_obj.user_id = self.id
      hist_obj.old =old_value
      hist_obj.new =self.hourly_rate
      hist_obj.save
    end
  end
end
