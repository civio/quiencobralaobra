class AddHighlightedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :highlighted, :boolean, default: false, null: false
  end
end
