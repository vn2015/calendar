class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :IsAdmin?
  helper_method :CheckAccess?

  WillPaginate.per_page = 1







  protected

  def after_sign_in_path_for(resource)
      events_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:dob, :first_name, :last_name,:notes ])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:dob, :first_name, :last_name,:notes ])

  end

  def getUser
    User.where(is_admin:false)
  end

  def getBufferTime
    return @buffer_time ||= Setting.first()["buffer_time"]
  end

   def getReportEmail
     @report_email ||= Setting.first()["email_report"]
   end


   def IsAdmin?
    if current_user.is_admin==true
      return true
    else
      return false
    end
   end

   def CheckAccess?
     if !IsAdmin?
       redirect_to events_path, alert: 'Access denied!'
     end
   end



end
