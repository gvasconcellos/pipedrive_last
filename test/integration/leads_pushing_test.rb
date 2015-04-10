require 'test_helper'

class LeadsPushingTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:jonas)
    log_in(@user)
    @lead = @user.leads.new({   name: "MyString2",
                  last_name: "MyString2",
                  email: "MyString2",
                  company: "MyString2",
                  job_title: "MyString2",
                  phone: 1,
                  website: "MyString2" } )
    @lead.save
  end

test "should create and push lead while integrated" do
 	#simulating integration (editing app_key with a valid value)
 	get edit_user_path(@user)
  	app_key = TRIAL_APP_KEY?
  	patch user_path(@user), user: { app_key: app_key }
  	@user.reload
  	#app key is correct
  	assert_equal @user.app_key, app_key, "app key (trial) may have expired"
  	#custom field keys were obtained 
  	#(doesn't matter if they already existed or not)
  	assert @user.field_key["Job Title"]
  	assert @user.field_key["Website"]
    assert_difference('Lead.count') do
     post leads_path, lead: { company: @lead.company,
      						email: @lead.email,
      						job_title: @lead.job_title,
      						last_name: @lead.last_name,
      						name: @lead.name,
      						phone: @lead.phone,
      						website: @lead.website }
    end
  	assert_redirected_to lead_path(assigns(:lead))
  	assert_not flash.empty?
  	assert_equal 'Lead was successfully created and integrated', flash[:notice]
  end
end
