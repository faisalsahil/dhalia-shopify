class ResubscribesController < ApplicationController
	def create
		@resubscribe = Resubscribe.new(params[:resubscribe])
		@resubscribe.save!
		flash[:notice] = "Successfully create."
		redirect_to mc_keys_path
	end

	def update
		@resubscribe = Resubscribe.find(params[:id])
		@resubscribe.update_attributes(params[:resubscribe])
		flash[:notice] = "Successfully update."
		redirect_to mc_keys_path
	end
end
