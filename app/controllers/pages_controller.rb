class PagesController < ApplicationController

  def the_law
    @page_index = params[:id]
    @page_prev = ( @page_index > 0 ) ? method('the_law_'+(params[:id]-1).to_s+'_path').call : nil;
    @page_next = ( @page_index < 8 ) ? method('the_law_'+(params[:id]+1).to_s+'_path').call : nil;

    render 'the_law_'+params[:id].to_s
  end
end
