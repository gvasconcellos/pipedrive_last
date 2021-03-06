class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]
	before_action :correct_user, only: [:edit, :update]

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			log_in @user
			if @user.app_key.blank? || !User.assert_or_integrate(@user)
				redirect_to root_path, notice: "User successfully created. \
										App Key is either empty or invalid. "
			else
				redirect_to root_path, notice: "User successfully created and Integrated"
			end
		else
			render action: "new"
		end
	end

	def edit
		#app_key only
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
    	respond_to do |format|
      		if @user.update(user_params) && User.assert_or_integrate(@user)
      			format.html { redirect_to leads_path, notice: 'App Key was successfully updated.' }
	        	format.json { render :show, status: :ok, location: leads_path }
      		else
	        	format.html { redirect_to edit_user_path(@user), notice: "Invalid Pipedrive App Key" }
        		format.json { render json: @user.errors, status: :unprocessable_entity }
      		end
    	end
  	end

	def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :app_key, :field_key)
    end

    private

    def logged_in_user
    	unless logged_in?
    		redirect_to root_path, notice: 'Please Log In'
    	end
    end

    def correct_user
    	@user = User.find(params[:id])
    	unless @user == current_user
    		redirect_to root_path, notice: 'Cant edit other users' 
    	end
    end

end