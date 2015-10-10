class CreateAwards < ActiveRecord::Migration
  def change
    enable_extension "hstore"
    create_table :awards do |t|
      t.references :public_body, index: true, null: false
      t.references :bidder, index: true, null: false      
      t.date :award_date
      t.integer :amount
      t.hstore :properties

      t.timestamps null: false
    end
    add_index :awards, :properties
  end
end
