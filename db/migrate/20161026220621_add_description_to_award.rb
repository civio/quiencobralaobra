class AddDescriptionToAward < ActiveRecord::Migration
  def change
    add_column :awards, :description, :string
  end
end
