require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup info" do
  	get new_user_path
  	assert_no_difference 'User.count' do
  		post users_path, user: { name: "",
  								email: "not@valid",
  								password: "abc",
  								password_confirmation: "abc"}
  	end
  	assert_template 'users/_form'
  	assert_template 'users/new'
  	assert_template 'layouts/application'
  end

  test "valid signup info" do
  	get new_user_path
  	assert_difference 'User.count', 1 do
  		post_via_redirect users_path, user: { 	name: "Testing",
  												email: "user@testing.com",
  												password: "abcde",
  												password_confirmation: "abcde"}
		end
		assert_template 'login/_form'
		assert_template 'login/new'
		assert_template 'layouts/application'
	end
end
