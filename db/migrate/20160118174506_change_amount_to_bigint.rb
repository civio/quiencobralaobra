class ChangeAmountToBigint < ActiveRecord::Migration
  def change
    change_column :awards, :amount, :bigint
  end
end
