class HomeController < ApplicationController

  def index
    @articles = (can? :manage, Article) ? Article.all : Article.published
  end

  def about_us
  end
end
