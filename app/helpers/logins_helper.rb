module LoginsHelper
	
	def log_in(user)
		session[:user_id] = user.id
	end

	def log_out
		session.clear
	end

	def logged_in?
		!current_user.nil?
	end
end