class WebhooksController < ApplicationController

	def create
		@webhook = Webhook.new(params[:webhook])
		@webhook.save!
		flash[:notice] = "Webhook URL successfully save."
		redirect_to mc_keys_path
	end

	def index    #========= this function called by webhook response from MailChimp

		@mc_key = McKey.first
		gb = Gibbon::API.new(@mc_key.key)
        Gibbon::API.api_key = @mc_key.key
        Gibbon::API.timeout = 15
        Gibbon::API.throws_exceptions = false
        @email = "faisal.bhatti@devsinc.com"   #get email from webhook response params
        options = Array.new
        flag = Gibbon::API.lists.merge_var_add(:id => @mc_key.list, :tag=>"COUPON", :name=>"coupon", :options=> options)
        flag = Gibbon::API.lists.merge_var_add(:id => @mc_key.list, :tag=>"USED", :name=>"used", :options=> options)

        response = EmailChecking(@email)   #this email get from params
        if response.blank?	# if email id does not exist in DB then we assign a coupon
        	response = main_function(@mc_key,@email)
        	if response == true
	    		flash[:notice] = "Process Successfully."
	    		puts "Successfull"
	    		#  ============ redirect path
	    	end
        else           # if email exist and can we assign another token or not.
        	@re_subscribe = Resubscribe.first
        	if @re_subscribe && @re_subscribe.re_subscribe.present?
        		response = main_function(@mc_key,@email)
	        	if response == true
		    		flash[:notice] = "Process Successfully."
		    		#  ============ redirect path
		    		puts "another successfull"
		    	end
        	else
        		flash[:notice] = "Email already exist. We can't provide another coupon."
        		# redirect_to  path
        		puts "unSuccessfull"
        	end
        end
	end

	def main_function(mc_key,email)
		gb = Gibbon::API.new(mc_key.key)
        Gibbon::API.api_key = mc_key.key
        Gibbon::API.timeout = 15
        Gibbon::API.throws_exceptions = false
		coupon = getCoupon()
    	if coupon.present?
    		wh_log(@email+"-->"+coupon.coupon_code)
        	flag = Gibbon::API.lists.subscribe(:id =>  mc_key.list,
	                      :email => {:email => email},
	                      :merge_vars=>{'COUPON'=>coupon.coupon_code},
	                      :double_optin   => false,
	                      :update_existing=> true
	                      )
        	if !defined?(flag.status)
	    		response = updateCoupon(coupon.coupon_code,email)
	    		return response
		    end
    	else
    		return '-1'
    	end
	end

	def EmailChecking(email)
	    record = Coupon.find_by_subscriber_email(email)
	    return record
	end

	def getCoupon()
	    coupon = Coupon.where(:used=>'0', :subscriber_email=>'').first
	    # wh_log(print_r(coupon,true))
	    return coupon	
	end

	def updateCoupon(code,email)
	   	coupon = Coupon.find_by_coupon_code(code)
	   	if coupon
	   		coupon.subscriber_email = email
	   		coupon.save!
	   		return true
	   	else	
	   		return false
	   	end
	end

	def wh_log(msg)
    	# logfile = 'webhook.log'
    	# file_put_contents(logfile,msg+"\n",FILE_APPEND)
	end
end
