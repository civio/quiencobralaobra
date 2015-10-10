class CreateBidders < ActiveRecord::Migration
  def change
    create_table :bidders do |t|
      t.string :name
      t.string :slug
    end
  end
end
