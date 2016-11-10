class AwardsController < ApplicationController
  def index
    # Get 'Grupos', 'Administraciones' & 'Tipo de procedimientos de contratos' for filter selects
    @bidders = Bidder.select(:group, :slug).distinct.where(<<-EOQ).order(group: :asc)
                 "bidders"."group" NOT IN (
                   SELECT ute
                   FROM ute_companies_mappings
                 )
               EOQ
    @public_bodies = PublicBody.all.order(name: :asc)
    @contract_awards_types = Award.select(:process_type).distinct.each{ |a| a.process_type.blank? ? a.process_type = "Sin información" : a.process_type }.sort{ |a, b| a.process_type <=> b.process_type }

    # Get 'Contratos' paginated & order by amount
    awards = Award.includes(:public_body, :bidder)

    awards = awards.where(bidders: { slug: params[:bidder] }) unless params[:bidder].blank?

    awards = awards.where(public_body: params[:public_body]) unless params[:public_body].blank?

    process_type = params[:process_type] unless params[:process_type].blank?
    process_type = "" if process_type == "Sin información"
    awards = awards.where(process_type: process_type) unless process_type.nil?

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
    end

    @contract_awards = awards.order(amount: :desc)
  end

  def show
    @award = Award.find_by_slug!(params[:id])
    @hasAwardExtraInfo = !@award.properties['Presupuesto base de licitación'].blank? && !@award.properties['Análisis - Ámbito geográfico'].blank?
  end

  private

  def paginate?
    # TODO: find a better way to identify amount filter 'blank' value
    [params[:bidder], params[:public_body], params[:process_type], params[:start], params[:end]].all?(&:blank?) && params[:amount] == "0;370000000"
  end
end
