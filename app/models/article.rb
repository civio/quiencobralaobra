class Article < ActiveRecord::Base
  acts_as_url :title, url_attribute: :slug
  def to_param
    slug
  end

  def related_entities
    [Bidder.first, PublicBody.first]  # FIXME
  end
end