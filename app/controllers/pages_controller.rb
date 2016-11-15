class PagesController < ApplicationController

  def gallery
    @title = 'Galería de superobras'
  end
  
  def the_law
    @title = 'Guía de la Ley'
  end

  def glossary
    @title = 'Glosario'
  end

  def methodology
    @title = 'Metodología'
  end

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
                "is_ute" IS NOT True
              EOQ

    search = "%#{params[:search]}%"
    @public_bodies = PublicBody.where(<<-EOQ, search)
                       name ILIKE ?
                     EOQ
  end
end
