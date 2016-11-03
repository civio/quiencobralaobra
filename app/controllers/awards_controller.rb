class AwardsController < ApplicationController
  def index
    # Get 'Empresas', 'Administraciones' & 'Tipo de procedimientos de contratos' for filter selects
    @bidders = Bidder.select(:group, :slug).distinct.order(group: :asc)
    @public_bodies = PublicBody.all.order(name: :asc)
    @contract_awards_types = Award.select(:process_type).distinct.order(process_type: :asc)

    # Get 'Contratos' paginated & order by amount
    awards = Award.includes(:public_body, :bidder)
    awards = awards.where(bidders: { slug: params[:bidder] }) unless params[:bidder].blank?
    awards = awards.where(public_body: params[:public_bodies]) unless params[:public_bodies].blank?
    @contract_awards = awards.page(params[:page]).per(24).order(amount: :desc)
  end

  def show
    @award = Award.find_by_slug!(params[:id])
    @hasAwardExtraInfo = !@award.properties['Presupuesto base de licitación'].blank? && !@award.properties['Análisis - Ámbito geográfico'].blank?
  end
end
