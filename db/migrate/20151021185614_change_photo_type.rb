class ChangePhotoType < ActiveRecord::Migration
  def change
    remove_column :articles, :photo
    add_column :articles, :photo, :string
  end
end
