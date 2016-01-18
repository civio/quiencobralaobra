class HomeController < ApplicationController

  def index
    @articles_highlighted = Article.published.where( highlighted: true )

    @articles = (can? :manage, Article) ? Article.where( highlighted: false ) : Article.published.where( highlighted: false )
  end
end
