class AddFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :photo_id, :integer
    add_column :articles, :photo_footer, :string
    add_column :articles, :photo_credit, :string
    add_column :articles, :photo_credit_link, :string

    add_column :articles, :lead, :text
    add_column :articles, :author_id, :integer
    add_column :articles, :published, :boolean, default: false, null: false
    add_column :articles, :content, :text
    add_column :articles, :notes, :text
  end
end
