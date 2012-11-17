class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?

  def current_user
    current_owner || current_admin
  end
end
