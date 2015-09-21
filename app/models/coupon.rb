class Coupon < ActiveRecord::Base
  attr_accessible :coupon_code, :subscriber_email, :used

	def self.import(file)
		puts "---------------dsfgsdjgdfjdgsfhjgffhdgsfhu"
	  CSV.foreach(file.path, headers: true) do |row|
	    Coupon.create! row.to_hash
	  end
	end
end
