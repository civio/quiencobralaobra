class DataAnalysisController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # Show static page with data analysis actions
  def index
  end

  private
    def check_admin
      redirect_to new_user_session_path unless can? :manage, :all
    end
end
