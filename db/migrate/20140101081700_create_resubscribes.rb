class CreateResubscribes < ActiveRecord::Migration
  def change
    create_table :resubscribes do |t|
      t.boolean :re_subscribe

      t.timestamps
    end
  end
end
