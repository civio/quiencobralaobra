class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = (can? :manage, Article) ? Article.all : Article.published
    @articles_highlighted = @articles.where( highlighted: true )
    @articles = @articles.where( highlighted: false )
  end

  def show
    authorize! :read, @article
    @title = @article.title
  end

  private

    def set_article
      @article = Article.find_by_slug!(params[:id])
    end
end
