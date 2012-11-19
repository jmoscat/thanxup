class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to unauthorized_path
  end

  def current_user
    current_owner || current_admin
  end
end
