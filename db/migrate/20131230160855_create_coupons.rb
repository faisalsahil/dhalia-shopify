class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :coupon_code
      t.boolean :used
      t.string :subscriber_email

      t.timestamps
    end
  end
end
