class CouponsController < ApplicationController
	around_filter :shopify_session
	def new
		@coupon = Coupon.new
	end

	def remove
		@coupons = Coupon.all
		@coupons && @coupons.each do |coupon|
			if coupon.subscriber_email.blank?
				coupon.destroy
			end
		end
		flash[:notice] = "Unassigned Coupons Successfully Remove."
		redirect_to new_coupon_path
	end

	def import
		puts "===================================================="
	  Coupon.import(params[:file])
	  flash[:notice] = "Coupons imported."
	  redirect_to new_coupon_path
	end

	def update_coupon
		@coupon = Coupon.new
		# doing something here
	end

	def updateCoupons
	  
	    @start_date = Date.today.send(:-, 1.day)
	    @today_date = Date.today.send(:+, 1.day)
	    # DateTime.now.strftime('%m/%d/%Y')
	  	@products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
	  	@orders   = ShopifyAPI::Order.find(:all, :params => {:limit => 250,:created_at_min => "2014-02-13" ,:created_at_max => "2014-02-15", :order => "created_at DESC" })
		@arrayCoupons = []
		@orders.each do |ord|
			if ord.discount_codes.present?
				@email = ord.email;
				ord.discount_codes do |value|
					@arrayCoupons << {:email => @email,:code => value.code,:amount=> value.amount}
				end
			end
		end
	  	# @arrayCoupons <<{:email => "faisal.bhatti@devsinc.com",:code => "p8p10-ght4se3c",:amount=> "234"}


		if !@arrayCoupons.blank?
			puts "----------not empty---------------"
			response = updateCoupoms(@arrayCoupons)	
			if response == '-1'
				flash[:error] = "Please Enter MC API Key First."
			elsif response == true
				flash[:error] = "Coupons Successfully Update."
			elsif response == false
				flash[:error] = "Coupons Not Update On MailChimp."
			end
			redirect_to update_coupon_coupons_path		
		else
			flash[:notice] = "There is no coupon found against order to update. "
			redirect_to update_coupon_coupons_path
			puts "@arrayCoupons is empty--------------------"
		end
	end


	def updateCoupoms(coupons)
		coupons.each do |coupon|
			puts "00000000000000000000000000000000000000000"
			@code = coupon[:code]
			@email = coupon[:email]
			@amount = coupon[:amount]
			@coupon = Coupon.where(:coupon_code=>@code).first
			puts @coupon
			if @coupon
				puts "99999999999999999999999999999"
				@coupon.subscriber_email = @email
				@coupon.used = 1
				@coupon.save!
				@list_coupons = get_all_coupons_against_email(@email)
				response = UpdateMClist(@email,@list_coupons)
			end
		end
	end

	def get_all_coupons_against_email(email)
		coupon_string = ''
		index = 1
		@coupons = Coupon.all
		@coupons && @coupons.each do |coupon|
		    if coupon.subscriber_email  == email
		    	if index == 1
			    	coupon_string += coupon.coupon_code 
		    	else
			    	coupon_string += ','
			    	coupon_string += coupon.coupon_code
		    	end
		    	index+=1
		    end
		end
		return coupon_string
	end

	def UpdateMClist(email,code)
		@mc_key = McKey.first
		if @mc_key.present?
			gb = Gibbon::API.new(@mc_key.key)
	        Gibbon::API.api_key = @mc_key.key
	        Gibbon::API.timeout = 15
	        Gibbon::API.throws_exceptions = false

	        flag = Gibbon::API.lists.subscribe(:id =>  @mc_key.list,
		                      :email => {:email => email},
		                      :merge_vars=>{'COUPON'=>code,
		                              'USED'=>'true',
		                            },
		                      :double_optin   => false,
		                      :update_existing=> true
		                      )
		    if !defined?(flag.status)
		    	return true
		    else
		    	return false
		    end
		else
			return '-1'
		end
	end
end
