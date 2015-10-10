class PublicBody < ActiveRecord::Base
  has_many :awards, dependent: :delete_all

  has_many :mentions, as: :mentionee, inverse_of: :mentionee, dependent: :delete_all

  acts_as_url :name, url_attribute: :slug
  def to_param
    slug
  end

end