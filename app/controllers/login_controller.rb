class LoginController < ApplicationController
	def new
	end
	
	def create
		user = User.find_by_email(params[:user][:email])

		if user && user.valid_password?(params[:user][:password])
			session[:user_id] = user.id
			redirect_to leads_path, notice: "Logged in"
		else
			flash.now[:alert] = "Invalid info"
			redirect_to root_path, notice: "Invalid info"
			#render "new"
		end
	end

	def destroy
		#log_out if logged_in?
		session.clear
		#session[:user_id].clear
		redirect_to root_path
	end
end