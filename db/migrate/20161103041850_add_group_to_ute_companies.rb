class AddGroupToUteCompanies < ActiveRecord::Migration
  def change
    add_column :ute_companies_mappings, :group, :string
  end
end
