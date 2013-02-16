class ApplicationController < ActionController::Base
  before_filter :check_for_approval
  protect_from_forgery
  check_authorization unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to unauthorized_path
  end

  def current_user
    current_owner || current_admin
  end

  def validate_stripe
    redirect_to edit_payment_owner_path(id: current_owner.id), notice: 'Setup payment so you can begin working with Thanxup!' unless current_user and current_user.is_a?(Owner) and current_user.stripe_setup?
  end

  private

  def check_for_approval
    redirect_to unauthorized_path, notice: 'You have limited functionality while we approve your account. Please be patient' if current_owner && !current_owner.approved && (url_for =~ /campaign|coupon|store/ || url_for !~ /(\/thanxup\/(home|about|contact|privacy|terms|unauthorized){1}|\/owners\/\d(\/?\w*))/)
  end

end
