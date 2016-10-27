class Bidder < ActiveRecord::Base
  has_many :awards, dependent: :delete_all

  has_many :mentions, as: :mentionee, inverse_of: :mentionee, dependent: :delete_all

  acts_as_url :group, url_attribute: :slug, sync_url: true, allow_duplicates: true
  def to_param
    slug
  end

end