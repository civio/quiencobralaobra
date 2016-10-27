class MakeBiddersSlugIndexNotUnique < ActiveRecord::Migration
  def change
    remove_index :bidders, :slug
    add_index :bidders, :slug, unique: false
  end
end
