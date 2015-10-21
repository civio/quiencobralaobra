class Article < ActiveRecord::Base
  belongs_to :author, foreign_key: :author_id, class_name: User

  # these are outward mentions from the post content, not incoming!
  has_many :mentions_in_content, class_name: Mention, dependent: :delete_all, inverse_of: :article

  scope :published, -> { where(published: true) }

  acts_as_url :title, url_attribute: :slug
  def to_param
    slug
  end
end