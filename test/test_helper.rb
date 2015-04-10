ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def log_in(user)
    if integration_test?
      post_via_redirect login_path, user: { email: user.email,
                                  password: 'password'}
    else
      session[:user_id] = user.id
    end
  end

  def logged?
  	!session[:user_id].nil?
  end

  def log_out
  	session.delete(:user_id)
  	@current_user = nil
  end

  private

    def integration_test?
      defined?(post_via_redirect) || defined?(patch_via_redirect)
    end

    def TRIAL_APP_KEY?
      return "e124f874f8b066431f136cc85b07fbaf9a6c7a2b"
    end

  # Add more helper methods to be used by all tests here...
end
