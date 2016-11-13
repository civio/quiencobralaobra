class PublicBodiesController < ApplicationController
  before_action :set_public_body, only: [:show]

  def index
    @title = 'Administraciones'
    if params[:name]
      @public_bodies = PublicBody.where('"name" ILIKE ?', params[:name]+'%').order(name: :asc)
    else
      @public_bodies = PublicBody.all.page(params[:page]).per(50).order(name: :asc)
      @paginate = true
    end
  end

  def show
    @title = @public_body.name
    @title_prefix = @public_body.prefix

    @contract_awards = @public_body.awards.order(amount: :desc)
    @contract_awards_amount = @contract_awards.sum('amount')

    # Get some extra details for the 'robo-text'
    @close_bid_total = 0
    @contract_awards.each do |award|
      @close_bid_total+=award.amount if award.is_close_bid?
    end
  end

  private

    def set_public_body
      @public_body = PublicBody.includes(:awards).find_by_slug!(params[:id])
    end
end
