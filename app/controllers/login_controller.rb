class LoginController < ApplicationController

	def new
		if !session[:user_id].blank?
			redirect_to leads_path
		end
	end
	
	def create
		user = User.find_by_email(params[:user][:email])

		if user && user.valid_password?(params[:user][:password])
			log_in user
			redirect_to leads_path, notice: "Logged in"
		else
			redirect_to root_path, notice: "Invalid info"
		end
	end

	def destroy
		log_out unless current_user.blank?
		redirect_to root_path
	end
end