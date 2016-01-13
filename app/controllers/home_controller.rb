class HomeController < ApplicationController

  def index
    @articles = (can? :manage, Article) ? Article.all : Article.published
  end
end
