class LoginController < ApplicationController
	def new
	end
	
	def create
		user = User.find_by_email(params[:user][:email])

		if user && user.valid_password?(params[:user][:password])
			session[:user_id] = user.id
			redirect_to leads_path, notice: "Logged in"
		else
			redirect_to root_path, notice: "Invalid info"
		end
	end

	def destroy
		session.clear
		redirect_to root_path
	end
end