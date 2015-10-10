class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @articles = Article.all
  end

  def show
    @title = @article.title
  end

  private

    def set_article
      @article = Article.find_by_slug!(params[:id])
    end
end
