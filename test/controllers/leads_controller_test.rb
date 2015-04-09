require 'test_helper'

class LeadsControllerTest < ActionController::TestCase
  setup do
  	@user = users(:jonas)
  	log_in(@user)
    @lead = @user.leads.new({ 	name: "MyString",
    							last_name: "MyString",
  								email: "MyString",
  								company: "MyString",
  								job_title: "MyString",
  								phone: 1,
  								website: "MyString" } )
    @lead.save
    #@lead = leads(:lead_one)
    #@user = User.new(name: "Testing User", email: "testing@user.com",
  	#				password: "foobar", password_confirmation: "foobar")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:leads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lead while not integrated" do
    assert_difference('Lead.count') do
      post :create, lead: { company: @lead.company,
      						email: @lead.email,
      						job_title: @lead.job_title,
      						last_name: @lead.last_name,
      						name: @lead.name,
      						phone: @lead.phone,
      						website: @lead.website }
    end
  	assert_redirected_to lead_path(assigns(:lead))
  	assert_not flash.empty?
  	#further checking will be made on the gem
  	assert_equal 'Lead was successfully created but not integrated', flash[:notice]
  end

  test "should create lead while integrated" do
  	log_out
  	@other_user = users(:tadeu)
  	log_in(@other_user)
    @lead = @other_user.leads.new({ name: "MyString",
    								last_name: "MyString",
  									email: "MyString",
  									company: "MyString",
  									job_title: "MyString",
  									phone: 1,
  									website: "MyString" } )
    @lead.save
    assert_difference('Lead.count') do
      post :create, lead: { company: @lead.company,
      						email: @lead.email,
      						job_title: @lead.job_title,
      						last_name: @lead.last_name,
      						name: @lead.name,
      						phone: @lead.phone,
      						website: @lead.website }
    end
  	assert_redirected_to lead_path(assigns(:lead))
  	assert_not flash.empty?
  	#further checking will be made on the gem
  	assert_equal 'Lead was successfully created and integrated', flash[:notice]
  end

  test "should show lead" do
    get :show, id: @lead
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lead
    assert_response :success
  end
#
  test "should update lead" do
    patch :update, id: @lead, lead: { company: @lead.company,
    								  email: @lead.email,
    								  job_title: @lead.job_title,
    								  last_name: @lead.last_name,
    								  name: @lead.name,
    								  phone: @lead.phone,
    								  website: @lead.website }
    assert_redirected_to lead_path(assigns(:lead))
  end
#
  test "should destroy lead" do
    assert_difference('Lead.count', -1) do
      delete :destroy, id: @lead
    end

    assert_redirected_to leads_path
  end
  
end