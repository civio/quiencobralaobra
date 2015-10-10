class BiddersController < ApplicationController
  before_action :set_bidder, only: [:show]

  def index
    @bidders = Bidder.all
  end

  def show
    @title = @bidder.name
    @contract_awards = []
  end

  private

    def set_bidder
      @bidder = Bidder.find_by_slug!(params[:id])
    end
end
