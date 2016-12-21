class Program < ApplicationRecord
  has_many :events, :dependent => :delete_all
  has_many :program_status_histories, :dependent => :delete_all
  before_update :histoty_create

  validates :name, presence: true

  protected

  def histoty_create
      old_value = Program.find(self.id).is_paid
      logger.debug old_value
      logger.debug self.is_paid
      if old_value!=self.is_paid
          hist_obj =ProgramStatusHistory.new
          hist_obj.program_id = self.id
          hist_obj.old =old_value==1?true:false
          hist_obj.new =self.is_paid==1?true:false
          hist_obj.save
      end
  end

end
