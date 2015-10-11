class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Handle unauthorized access to the admin interface
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  # After successful login, go to admin page. (We don't have non-admin users.)
  def after_sign_in_path_for(resource)
    rails_admin.dashboard_path
  end
end
