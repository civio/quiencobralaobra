class AddIndexToBidders < ActiveRecord::Migration
  def change
    add_index :bidders, :group, unique: false
  end
end
