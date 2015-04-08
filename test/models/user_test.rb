require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: "Testing User", email: "testing@user.com",
  					password: "foobar", password_confirmation: "foobar")
  end

  test "should be OK" do
  	assert @user.valid?
  end

  test "name must exist" do
  	@user.name = ""
  	assert_not @user.valid?
  end

  test "email must exist" do
  	@user.email = ""
  	assert_not @user.valid?
  end

  test "max name length" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "max email length" do
  	@user.name = "a" * 241 + "test.com"
  	assert_not @user.valid?
  end

  test "valid email is valid" do
  	valid_emails = %w[foo@bar.com USER@bla.com a-B-c_Est@a.b.c.org
  					no.more+ideas123@whatever.au]
  	valid_emails.each do |valid_email|
  		@user.email = valid_email
  		assert @user.valid?, "#{valid_email.inspect} should be valid"
  	end
  end

  test "invalid email is invalid" do
  	invalid_emails = %w[foo@bar,com USERbla.com a-B-c_Est@a.b.c.
  					no.more+ideas123@wha+tever.au no@under_score.com]
  	invalid_emails.each do |invalid_email|
  		@user.email = invalid_email
  		assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
  	end
  end

  test "email should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "password minimum length" do
  	@user.password = @user.password_confirmation = "a" * 4
  	assert_not @user.valid?
  end

end
