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
    @contract_awards = @public_body.awards.order(amount: :desc)
    @contract_awards_amount = @contract_awards.sum('amount')
    @title_prefix = ''
    if @public_body.body_type == 'Ministerios' or @title.downcase.start_with?('ajuntament', 'área', 'ayuntamiento', 'cabildo', 'centro', 'consejo', 'consell', 'consorci', 'tribunal')
      @title_prefix = 'el ' 
    elsif @public_body.body_type == 'Comunidades Autónomas' or @title.downcase.start_with?('comunidad', 'diputación', 'fundaci', 'mancomunidad', 'universi')
      @title_prefix = 'la '
    end
  end

  private

    def set_public_body
      @public_body = PublicBody.includes(:awards).find_by_slug!(params[:id])
    end
end
