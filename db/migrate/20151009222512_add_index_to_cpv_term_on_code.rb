class AddIndexToCpvTermOnCode < ActiveRecord::Migration
  def change
    add_index :cpv_terms, :code
  end
end
