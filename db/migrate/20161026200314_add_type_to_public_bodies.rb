class AddTypeToPublicBodies < ActiveRecord::Migration
  def change
    add_column :public_bodies, :body_type, :string
    add_index :public_bodies, :body_type, unique: false
  end
end
