class BiddersController < ApplicationController
  before_action :set_bidder, only: [:show]

  def index
    @bidders = Bidder.select(:group, :slug).distinct.page(params[:page]).per(24).order(group: :asc)
  end

  def show
    @title = @bidder.group
    @contract_awards = Award.joins(:bidder).where('bidders.group = ?', @bidder.group).order(amount: :desc)
    @contract_awards_utes = Award.joins(:bidder).where('bidders.group = ?', @bidder.group).order(amount: :desc)
    @contract_awards_amount = @contract_awards.sum('amount')
    @contract_awards_utes_amount = @contract_awards_utes.sum('amount')
  end

  private

    def set_bidder
      @bidder = Bidder.includes(:awards).find_by_slug!(params[:id])
    end
end
