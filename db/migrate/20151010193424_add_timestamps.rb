class AddTimestamps < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.timestamps
    end
    change_table :bidders do |t|
      t.timestamps
    end
    change_table :public_bodies do |t|
      t.timestamps
    end
  end
end
