class PublicBody < ActiveRecord::Base
  has_many :awards, dependent: :delete_all

  has_many :mentions, as: :mentionee, inverse_of: :mentionee, dependent: :delete_all

  acts_as_url :name, url_attribute: :slug
  def to_param
    slug
  end

  def prefix
    if body_type == 'Ministerios' or name.downcase.start_with?('ajuntament', 'área', 'ayuntamiento', 'cabildo', 'centro', 'consejo', 'consell', 'consorci', 'tribunal')
      'el '
    elsif body_type == 'Comunidades Autónomas' or name.downcase.start_with?('comunidad', 'diputación', 'fundaci', 'mancomunidad', 'universi')
      'la '
    end
  end
end