class Article < ActiveRecord::Base
  # these are outward mentions from the post content, not incoming!
  has_many :mentions_in_content, class_name: Mention, dependent: :delete_all, inverse_of: :article

  acts_as_url :title, url_attribute: :slug
  def to_param
    slug
  end
end