class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  WillPaginate.per_page = 10

  protected

  def after_sign_in_path_for(resource)
      events_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:username,:email_report,:buffer_time])
  end

end
