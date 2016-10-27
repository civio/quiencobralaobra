class BiddersController < ApplicationController
  before_action :set_bidder, only: [:show]

  def index
    @bidders = Bidder.select(:group, :slug).distinct.page(params[:page]).per(24).order(group: :asc)
  end

  def show
    @title = @bidder.group
    @contract_awards = Award.joins(:bidder).where('bidders.group = ?', @bidder.group).order(amount: :desc)
  end

  private

    def set_bidder
      @bidder = Bidder.includes(:awards).find_by_slug!(params[:id])
    end
end
