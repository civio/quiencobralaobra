class AddSlugToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :slug, :string
    add_index :awards, :slug, unique: true

    Award.initialize_urls
  end
end
