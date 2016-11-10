class AddIsUteToBidder < ActiveRecord::Migration
  def change
    add_column :bidders, :is_ute, :boolean
    add_index :bidders, :is_ute
  end
end
