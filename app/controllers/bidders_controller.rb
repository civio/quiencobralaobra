class BiddersController < ApplicationController
  before_action :set_bidder, only: [:show]

  def index
    @bidders = Bidder.all.page(params[:page]).per(24).order(name: :asc)
  end

  def show
    @title = @bidder.name
    @contract_awards = @bidder.awards.order(amount: :desc)
  end

  private

    def set_bidder
      @bidder = Bidder.includes(:awards).find_by_slug!(params[:id])
    end
end
