class AwardsController < ApplicationController
  def index
    # FIXME: ¿Qué se supone que mostramos aquí? ¿Las empresas con más adjudicaciones?
    @bidders = Bidder.all.order(name: :asc)

    @public_bodies = PublicBody.all.order(name: :asc)

    @contract_awards = Award.includes(:public_body, :bidder).all.order(amount: :desc)

    @contract_awards_types = Award.select(:process_type).distinct.order(process_type: :asc)
  end

  def show
    @award = Award.find_by_id(params[:id])
  end
end
