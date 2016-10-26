class AddBoeIdToAward < ActiveRecord::Migration
  def change
    add_column :awards, :boe_id, :string
  end
end
