class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)

		if @user.save
			redirect_to root_path, notice: "User successfully created"
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
      		if @user.update(user_params)
        		format.html { redirect_to leads_path, notice: 'App Key was successfully updated.' }
	        	format.json { render :show, status: :ok, location: leads_path }
      		else
	        	format.html { render :edit }
        		format.json { render json: @user.errors, status: :unprocessable_entity }
      		end
    	end
  	end


	def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :app_key)
    end
end