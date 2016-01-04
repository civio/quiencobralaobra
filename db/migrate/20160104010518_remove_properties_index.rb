class RemovePropertiesIndex < ActiveRecord::Migration
  def change
    remove_index :awards, :properties
  end
end
