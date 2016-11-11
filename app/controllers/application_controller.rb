class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  WillPaginate.per_page = 10
end
