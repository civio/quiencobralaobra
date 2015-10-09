class CreateCpvTerms < ActiveRecord::Migration
  def change
    create_table :cpv_terms do |t|
      t.string :code
      t.string :description

      t.timestamps null: false
    end
  end
end
