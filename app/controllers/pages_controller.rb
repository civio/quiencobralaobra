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

    search = "%#{params[:search]}%"
    @groups = Bidder.select(:group, :slug).distinct.where(<<-EOQ, search)
                "group" ILIKE ? AND
                "group" NOT IN (
                  SELECT ute
                  FROM ute_companies_mappings
                )
              EOQ

    search = "%#{params[:search]}%"
    @public_bodies = PublicBody.where(<<-EOQ, search)
                       name ILIKE ?
                     EOQ
  end
end
