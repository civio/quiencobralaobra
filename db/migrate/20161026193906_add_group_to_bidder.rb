class AddGroupToBidder < ActiveRecord::Migration
  def change
    add_column :bidders, :group, :string
    add_column :bidders, :acronym, :string
  end
end
