class Award < ActiveRecord::Base
  belongs_to :public_body
  belongs_to :bidder
end