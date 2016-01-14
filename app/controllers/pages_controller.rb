class PagesController < ApplicationController

  def the_law
    @page_index = params[:id]

    render 'the_law_'+params[:id].to_s
  end
end
