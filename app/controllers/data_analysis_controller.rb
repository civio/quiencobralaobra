class DataAnalysisController < ApplicationController
  layout "data_analysis"

  before_filter :check_admin

  # Show static page with data analysis actions
  def index
  end

  def cpv_not_available
    @analysis_name = "CPV no disponible"

    @total_contracts = Award.all.size
    @contract_awards = Award
        .where("properties @> hstore('Objeto del contrato - CPV (Referencia de Nomenclatura)', null)")
  end

  private
    def check_admin
      redirect_to new_user_session_path unless can? :manage, :all
    end
end
