class RenamePhotoField < ActiveRecord::Migration
  def change
    rename_column :articles, :photo_id, :photo
  end
end
