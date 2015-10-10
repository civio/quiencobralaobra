class Mention < ActiveRecord::Base
  belongs_to :article, inverse_of: :mentions_in_content
  belongs_to :mentionee, polymorphic: true, inverse_of: :mentions
end
