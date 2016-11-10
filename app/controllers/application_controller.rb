class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Define helpers for year min & year max 
  helper_method :year_min, :year_max

  # Handle unauthorized access to the admin interface
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  # After successful login, go to admin page. (We don't have non-admin users.)
  def after_sign_in_path_for(resource)
    rails_admin.dashboard_path
  end

  # we use year_min & year_max to define data temporal range
  # we use this values in different views, so we have to update it if we add data for other years
  def year_min
    return 2009
  end

  def year_max
    return 2015
  end
end
