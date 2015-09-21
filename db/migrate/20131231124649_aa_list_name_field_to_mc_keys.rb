class AaListNameFieldToMcKeys < ActiveRecord::Migration
  def change
  	add_column :mc_keys, :list_name, :string
  end
end
