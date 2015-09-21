class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.string :url

      t.timestamps
    end
  end
end
