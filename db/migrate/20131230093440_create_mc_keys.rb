class CreateMcKeys < ActiveRecord::Migration
  def change
    create_table :mc_keys do |t|

      t.timestamps
    end
  end
end
