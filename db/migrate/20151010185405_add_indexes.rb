class AddIndexes < ActiveRecord::Migration
  def change
    add_index :public_bodies, :name, unique: true
    add_index :public_bodies, :slug, unique: true

    add_index :bidders, :name, unique: true
    add_index :bidders, :slug, unique: true

    add_index :articles, :title, unique: true
    add_index :articles, :slug, unique: true
  end
end
