class PublicBodiesController < ApplicationController
  before_action :set_public_body, only: [:show]

  def index
    @public_bodies = PublicBody.all.page(params[:page]).per(24).order(name: :asc)
  end

  def show
    @title = @public_body.name
    @contract_awards = @public_body.awards
  end

  private

    def set_public_body
      @public_body = PublicBody.includes(:awards).find_by_slug!(params[:id])
    end
end
