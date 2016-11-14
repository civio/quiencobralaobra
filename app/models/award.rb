require 'bigdecimal'

class Award < ActiveRecord::Base
  belongs_to :public_body
  belongs_to :bidder

  acts_as_url :boe_id, url_attribute: :slug
  def to_param
    slug
  end

  def is_close_bid?
    return process_type.start_with? 'Negociado'
  end

  def is_ute?
    !UteCompaniesMapping.get_ute_groups(bidder.name).nil?
  end

  def get_ute_groups
    UteCompaniesMapping.get_ute_groups(bidder.name)
  end
end