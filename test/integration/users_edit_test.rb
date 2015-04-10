require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  	def setup
  		@user = users(:jonas)
  		@other_user = users(:tadeu)
  	end

  	test "should redirect when not logged" do
  		get edit_user_path(@user)
  		assert_not flash.empty?
  		assert_redirected_to root_path
  	end

  	test "should redirect when logged as another user" do
  		log_in(@other_user)
  		get edit_user_path(@user)
  		assert_not flash.empty?
  		assert_redirected_to root_path
  	end

  	test "incorrect API key inserted" do 
  		log_in(@user)
  		get edit_user_path(@user)
  		assert_template 'users/edit'
  		#name = "whatever"
  		#email = "what@ever.com"
  		app_key = "invalid_api_info"
  		patch user_path(@user), { user: { app_key: app_key } }
  		assert_redirected_to edit_user_path(@user)
  		follow_redirect!
  		assert_template 'users/edit'
  		assert_not flash.empty?
  		@user.reload
  		assert @user.app_key.blank?
  		assert @user.field_key["Job Title"].blank?
  		assert @user.field_key["Website"].blank?
  	end

  	test "correct API key inserted and integrated with pipedrive" do 
  		log_in(@user)
  		get edit_user_path(@user)
  		assert_template 'users/edit'
  		app_key = TRIAL_APP_KEY?
  		patch user_path(@user), user: { app_key: app_key }
  		assert_redirected_to leads_path
  		follow_redirect!
  		assert_template 'leads/index'
  		assert_not flash.empty?
  		@user.reload
  		#app key is correct
  		assert_equal @user.app_key, app_key, "app key (trial) may have expired"
  		#custom field keys were obtained 
  		#(doesn't matter if they already existed or not)
  		assert @user.field_key["Job Title"]
  		assert @user.field_key["Website"]
  	end

end
