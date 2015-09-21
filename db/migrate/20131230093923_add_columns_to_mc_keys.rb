class AddColumnsToMcKeys < ActiveRecord::Migration
  def change
  	add_column :mc_keys, :key, :string
  	add_column :mc_keys, :list, :string
  end
end
