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

  test "signup with duplicated email" do
    get new_user_path
    assert_no_difference 'User.count' do
      post_via_redirect users_path, user: {   name: "Testing",
                          email: "jonas@trindoce.com",
                          password: "abcde",
                          password_confirmation: "abcde"}
    end
  end

  test "valid signup info + initial integration" do
  	get new_user_path
  	assert_difference 'User.count', 1 do
  		post_via_redirect users_path, user: { 	name: "Testing",
  												email: "user@testing.com",
                          app_key: "cbf8f6b10b70e4b77a8f658c2c39813451b2c965",
  												password: "abcde",
  												password_confirmation: "abcde"}
		end
		assert_template 'leads/index'
		assert_not flash.empty?
		assert logged?
    #integration successful
    @user = User.find_by_email("user@testing.com")
    assert @user.app_key
    assert @user.field_key["Job Title"]
    assert @user.field_key["Website"]
	end

  test "valid signup info with invalid APP KEY" do
    get new_user_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {   name: "Testing",
                          email: "user@testing.com",
                          app_key: "invalid_app_key",
                          password: "abcde",
                          password_confirmation: "abcde"}
    end
    assert_template 'leads/index'
    assert_not flash.empty?
    assert logged?
    #integration successful
    @user = User.find_by_email("user@testing.com")
    assert @user.app_key.blank?
    assert @user.field_key["Job Title"].blank?
    assert @user.field_key["Website"].blank?
  end
end
