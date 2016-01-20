class AwardsController < ApplicationController
  def index
    # FIXME: ¿Qué se supone que mostramos aquí? ¿Las empresas con más adjudicaciones?
    #@bidders = Bidder.all

    @contract_awards = Award.includes(:public_body, :bidder).all.order(amount: :desc)
  end

  def show
    @award = Award.find_by_id(params[:id])
  end
end
