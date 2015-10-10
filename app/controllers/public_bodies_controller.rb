class PublicBodiesController < ApplicationController
  before_action :set_public_body, only: [:show]

  def index
    @public_bodies = PublicBody.all
  end

  def show
    @title = @public_body.name
    @contract_awards = []
  end

  private

    def set_public_body
      @public_body = PublicBody.find_by_slug!(params[:id])
    end
end
