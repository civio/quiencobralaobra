class BiddersController < ApplicationController
  before_action :set_bidder, only: [:show]

  def index
    @title = 'Grupos constructores'

    @bidders = Bidder.select(:group, :slug).distinct.where(<<-EOQ, "#{params[:name]}%").order(slug: :asc)
                 "bidders"."slug" ILIKE ? AND
                 "bidders"."is_ute" IS NOT True
               EOQ

    if paginate?
      @pagination = true
      @page_count = (Bidder.from("(#{@bidders.to_sql}) groups").count / 50.to_f).ceil
      @bidders = @bidders.page(params[:page]).per(50)
    end
  end

  def show
    @title = @bidder.group
    @qm_id = qm_ids()
    @contract_awards = Award.includes(:bidder, :public_body) \
                          .where(bidders: { group: @bidder.group }) \
                          .order(amount: :desc)
    @contract_awards_amount = @contract_awards.sum('amount')

    # Getting the contracts via not-fully-controlled UTEs is a bit more tricky
    @contract_awards_utes = Award.joins('INNER JOIN bidders bidder ON awards.bidder_id=bidder.id') \
                              .joins('LEFT OUTER JOIN ute_companies_mappings ute_mapping ON bidder.name=ute_mapping.ute') \
                              .includes(:bidder, :public_body) \
                              .distinct \
                              .where(ute_mapping: { group: @bidder.group }) \
                              .where.not(bidder: { group: @bidder.group }) \
                              .order(amount: :desc)
                              # distinct: There can be multiple companies of the same group participating
                              # in the same UTE, so be careful to ask for distinct results to avoid
                              # getting multiple instances of the same award.
                              # where.not: UTEs fully belonging to a group are picked in a different place,
                              # so exclude them here: we just want UTEs where the group participates
                              # but doesn't fully control

    # We planned to do this to calculate the overall sum:
    #   @contract_awards_utes_amount = @contract_awards_utes.distinct.sum('amount')
    # but there's an issue in Rails with 'distinct' sums https://github.com/rails/rails/issues/16791
    @contract_awards_utes_amount = @contract_awards_utes.map(&:amount).inject(:+) || 0

    # Get some extra details for the 'robo-text'
    @contract_awards_total_amount = @contract_awards_amount + @contract_awards_utes_amount
    @close_bid_total = 0
    public_body_breakdown = {}
    (@contract_awards.to_a + @contract_awards_utes.to_a).each do |award|
      @close_bid_total+=award.amount if award.is_close_bid?

      public_body = award.public_body
      public_body_breakdown[public_body] = (public_body_breakdown[public_body]||0) + award.amount
    end
    @biggest_public_body = public_body_breakdown.max_by {|public_body, amount| amount }
  end

  private

    def set_bidder
      @bidder = Bidder.includes(:awards).find_by_slug!(params[:id])
    end

    def qm_ids 
      qm_ids = {
        'acs' => 'acs-actividades-de-construccion-y-servicios', 
        'acciona' => 'acciona',
        'comsa' => 'comsa-corporacion',
        'fcc' => 'fomento-de-construcciones-y-contratas',
        'copisa' => 'copisa',
        'grupo-ferrovial' => 'ferrovial',
        'grupo-sando' => 'construcciones-sanchez-dominguez-sando-sa',
        'grupo-villar-mir' => 'grupo-villar-mir',
        'isolux-corsan' => 'isolux',
        'sacyr' => 'sacyr'
      }
      return qm_ids[@bidder.slug]
    end

    def paginate?
      params[:name].blank?
    end
end
