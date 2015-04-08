require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:jonas)
  end

  test "login with invalid info" do
  	get login_path
  	assert_template 'login/new'
  	post_via_redirect login_path, user: {email: "", password: ""}
  	assert_template 'login/_form'
  	assert_template 'login/new'
  	assert_not flash.empty?
  end

  test "login with valid info then logout" do
  	get login_path
  	assert_template 'login/new'
  	post_via_redirect login_path, user: {email: @user.email, password: 'password'}
  	assert_template 'leads/index'
  	assert logged?
  	assert_select "a[href=?]", new_user_path, count: 0
  	assert_select "a[href=?]", login_path, count: 0
  	assert_select "a[href=?]", new_lead_path
  	assert_select "a[href=?]", leads_path
  	assert_select "a[href=?]", edit_user_path(@user)
  	assert_select "a[href=?]", logout_path
  	delete logout_path
  	assert_not logged?
  	assert_redirected_to root_url
  	delete logout_path
  	follow_redirect!
  	assert_select "a[href=?]", new_user_path
  	assert_select "a[href=?]", login_path
  end
end
