class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  WillPaginate.per_page = 10

  protected

  def after_sign_in_path_for(resource)
      events_path
  end
end
