class AwardsController < ApplicationController
  def index
    # Get 'Empresas', 'Administraciones' & 'Tipo de procedimientos de contratos' for filter selects
    @bidders = Bidder.select(:group, :slug).distinct.order(group: :asc)
    @public_bodies = PublicBody.all.order(name: :asc)
    @contract_awards_types = Award.select(:process_type).distinct.order(process_type: :asc)

    # Get 'Contratos' paginated & order by amount
    @contract_awards = Award.includes(:public_body, :bidder).page(params[:page]).per(24).order(amount: :desc)
  end

  def show
    @award = Award.find_by_id(params[:id])
    @hasAwardExtraInfo = !@award.properties['Presupuesto base de licitación'].blank? && !@award.properties['Análisis - Ámbito geográfico'].blank?
  end
end
