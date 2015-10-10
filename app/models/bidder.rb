class Bidder < ActiveRecord::Base
  acts_as_url :name, url_attribute: :slug
  def to_param
    slug
  end

end