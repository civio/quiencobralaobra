class AwardsController < ApplicationController
  def index
    @title = 'Buscador de contratos'
    # Get 'Grupos', 'Administraciones' & 'Tipo de procedimientos de contratos' for filter selects
    @bidders = Bidder.select(:group, :slug).distinct.where(is_ute: [nil, false]).order(slug: :asc)
    @public_bodies = PublicBody.all.order(name: :asc)
    @contract_awards_types = ["Abierto", "Negociado", "Otros"]

    # Get 'Contratos' paginated & order by amount.
    # We include not only awards won by groups on their own, but also via UTEs.
    awards = Award \
              .distinct \
              .joins('INNER JOIN bidders bidder ON awards.bidder_id=bidder.id') \
              .joins('LEFT OUTER JOIN ute_companies_mappings ute_mapping ON bidder.name=ute_mapping.ute') \
              .includes(:public_body, :bidder)

    # Filter by group, either on its own or via UTEs
    awards = awards.where('ute_mapping.group = ? OR bidder.group = ?', params[:bidder], params[:bidder]) unless params[:bidder].blank?

    awards = awards.where(public_body: params[:public_body]) unless params[:public_body].blank?

    process_type = params[:process_type]
    awards = awards.where(process_type: process_type) if process_type == "Abierto"
    awards = awards.where(process_type: ["Negociado", "Negociado con publicidad", "Negociado sin publicidad"]) if process_type == "Negociado"
    awards = awards.where.not(process_type: ["Abierto", "Negociado", "Negociado con publicidad", "Negociado sin publicidad"]) if process_type == "Otros"

    date_start = Date.parse(params[:start]) unless params[:start].blank?
    date_end = Date.parse(params[:end]) unless params[:end].blank?
    awards = awards.where("award_date >= ?", date_start) unless date_start.nil?
    awards = awards.where("award_date <= ?", date_end) unless date_end.nil?

    amount = params[:amount].split(';').map(&:to_i) unless params[:amount].blank?
    amount_start = amount.first * 100 unless amount.nil?
    amount_end = amount.last * 100 unless amount.nil?
    awards = awards.where("amount >= ?", amount_start) unless amount_start.nil?
    awards = awards.where("amount <= ?", amount_end) unless amount_end.nil?

    # setup amounts variables for amount range slider
    @amounts = [0, 100000, 200000, 500000, 1000000, 5225000, 12000000, 100000000, 370000000]
    @amount_min = amount ? @amounts.index(amount.first) : @amounts.first
    @amount_max = amount ? @amounts.index(amount.last) : @amounts.last

    if paginate?
      awards = awards.page(params[:page]).per(50)
      @pagination = true
      @contract_awards = awards.order(amount: :desc)
    else
      @contract_awards = awards.order(amount: :desc).limit(1000)
    end
  end

  def show
    @award = Award.find_by_slug!(params[:id])
    @hasAwardExtraInfo = !@award.properties['Presupuesto base de licitación'].blank? && !@award.properties['Análisis - Ámbito geográfico'].blank?
  end

  private

  def paginate?
    [params[:bidder], params[:public_body], params[:process_type], params[:start], params[:end]].all?(&:blank?) && (params[:amount].blank? || params[:amount] == "0;370000000")
  end
end
