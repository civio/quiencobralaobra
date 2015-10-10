class HomeController < ApplicationController

  def index
    @articles = Article.all
  end

  def about_us
  end
end
