class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = (can? :manage, Article) ? Article.all : Article.published
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
