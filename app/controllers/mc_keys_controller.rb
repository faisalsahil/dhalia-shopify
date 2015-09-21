class McKeysController < ApplicationController
	
	def index
		@mc_key = McKey.first
		if params[:list_loaded].present?
			@listloaded = params[:list_loaded]
			@key = params[:key]
			puts @key
		end
		if Webhook.first.present?
			@webhook = Webhook.first
		else
			@webhook = Webhook.new
		end
		
		@resubscribe = Resubscribe.first
		if @resubscribe.blank?
			@resubscribe = Resubscribe.new
		end
	end

	def new
		@mc_key  = McKey.new
		if params[:list_loaded].present?
			@listloaded = params[:list_loaded]
			@key = params[:key]
			puts @key
		end
	end

	def load_list
		if params[:key].present?
			@api_key = params[:key]
		    gb = Gibbon::API.new(@api_key)
		    Gibbon::API.api_key = @api_key
		    Gibbon::API.timeout = 15
		    Gibbon::API.throws_exceptions = false

		    # ------------load lists--------------

		    @lists = Gibbon::API.lists.list
		    puts @lists.inspect
		    if @lists["status"] == "error"
		        puts "error"
		        flash[:error]="Sorry! Please Enter Correct Api Key."
		        redirect_to :back
		    else
		        @listloaded = []
		        @lists['data'].each_with_index do |list, index|
		          @listloaded[index] = {}
		          @listloaded[index]["id"] = list["id"]
		          @listloaded[index]["name"] = list["name"]
		        end
		    # puts @listloaded.inspect
		    	if McKey.first.blank?
		    		redirect_to new_mc_key_path({:list_loaded => @listloaded, :key => @api_key})
		   		else
		    		redirect_to mc_keys_path({:list_loaded => @listloaded, :key => @api_key})
		    	end
		    end
		else
			flash[:error] = "Please enter MC API key."
			redirect_to :back
		end
	end

	def create
		@mc_key = McKey.new(params[:mc_key])
		puts params[:key]
		puts params[:mc_key][:list]
		@list_name = search_list_name(params[:mc_key][:list],params[:mc_key][:key])
		@mc_key.list_name = @list_name
		@mc_key.save!
		flash[:notice] = "MC API credendials successfully save."
		redirect_to mc_keys_path
	end

	def update
		@mc_key = McKey.find(params[:id])
		@mc_key.update_attributes(params[:mc_key])
		@list_name = search_list_name(@mc_key.list,@mc_key.key)
		@mc_key.list_name = @list_name
		@mc_key.save!
		flash[:notice] = "successfully Update."
		redirect_to mc_keys_path
	end

	def search_list_name(listid,apikey)
	    gb = Gibbon::API.new(apikey)
	    Gibbon::API.api_key = apikey
	    Gibbon::API.timeout = 15
	    Gibbon::API.throws_exceptions = false
	            # ------------load lists--------------
	    @list_name = ''
	    @lists = Gibbon::API.lists.list
	    @lists['data'].each_with_index do |list, index|
	      if listid == list["id"]
	        @list_name = list["name"]
	      end
	    end
	    return @list_name
	end
end
