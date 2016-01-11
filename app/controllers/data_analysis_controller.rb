class DataAnalysisController < ApplicationController
  layout "data_analysis"

  before_filter :check_admin
  before_filter :count_records

  # Show static page with data analysis actions
  def index
  end

  def show_attributes
    @analysis_name = "Atributos más comunes"
    query = "SELECT key, count(*) FROM \
        (SELECT (each(properties)).key, (EACH(properties)).VALUE FROM awards) AS stat \
        WHERE value IS NOT NULL \
        GROUP BY key \
        ORDER BY count DESC, key"
    @results = Award.connection.execute(query)
  end

  def cpv_not_available
    @analysis_name = "CPV no disponible"
    @contract_awards = Award
        .where("properties @> hstore('Objeto del contrato - CPV (Referencia de Nomenclatura)', null)")
  end

  private
    def check_admin
      redirect_to new_user_session_path unless can? :manage, :all
    end

    def count_records
      @total_contracts = Award.all.size
    end
end
