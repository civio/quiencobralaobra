class CreatePublicBodies < ActiveRecord::Migration
  def change
    create_table :public_bodies do |t|
      t.string :name
      t.string :slug
    end
  end
end
