class AddTypeToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :category, :string
    add_column :awards, :process_type, :string
    add_column :awards, :process_track, :string
  end
end
