class PagesController < ApplicationController
  def search
    search = Array.new(4, "%#{params[:search]}%")
    @awards = Award.joins(:public_body, :bidder).where(<<-EOQ, *search)
               bidders.name ILIKE ? OR
               bidders.group ILIKE ? OR
               public_bodies.name ILIKE ? OR
               awards.description ILIKE ?
             EOQ

    search = "%#{params[:search]}%"
    @articles = Article.where(<<-EOQ, search)
                  content ILIKE ?
                EOQ

    search = Array.new(2, "%#{params[:search]}%")
    @bidders = Bidder.where(<<-EOQ, *search)
                 name ILIKE ? OR
                 "group" ILIKE ?
               EOQ

    search = "%#{params[:search]}%"
    @public_bodies = PublicBody.where(<<-EOQ, search)
                       name ILIKE ?
                     EOQ
  end
end
