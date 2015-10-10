class Bidder < ActiveRecord::Base
  has_many :awards

  acts_as_url :name, url_attribute: :slug
  def to_param
    slug
  end

end