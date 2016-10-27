class CreateUteCompaniesMapping < ActiveRecord::Migration
  def change
    create_table :ute_companies_mappings do |t|
      t.string :ute
      t.string :company

      t.timestamps null: false
    end

    add_index :ute_companies_mappings, :ute, unique: false
    add_index :ute_companies_mappings, :company, unique: false
  end
end
