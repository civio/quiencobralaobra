class AddFeaturedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :featured, :boolean, default: false, null: false
  end
end
