require "bcrypt"

class User < ActiveRecord::Base
	has_many :leads
	serialize :field_key, Hash

	PIPEDRIVE_API = "https://api.pipedrive.com/v1/"
	TOKEN = "api_token="


## Local Authorization

	#allowing us to edit only APP_KEY from user
	validates_presence_of :email, :name, :password, :password_confirmation, on: :create
	validates_uniqueness_of :email
	validates_length_of :password, minimum: 5, maximum: 120, allow_blank: true
	validates_confirmation_of :password
	
	def password=(new_password)
		@password=new_password
		self.encrypted_password = BCrypt::Password.create(@password)
	end

	def password
		@password
	end

	def valid_password?(pass_to_validate)
		BCrypt::Password.new(encrypted_password) == pass_to_validate
	end

	## searches for "Job Title" and "Website" on the user's pipedrive acc
	## if any is missing, create it
	## even if populated the field key will always be replaced
	def self.assert_or_integrate(user)

		assert_job = false
		assert_website = false

		#query = 'https://api.pipedrive.com/v1/personFields?api_token=' + user.app_key
        query = PIPEDRIVE_API + 'personFields?' + TOKEN + user.app_key

		puts "query",query
      	response = HTTParty.get(query)
    	puts "response",response
      	if response["success"]
      		response["data"].each do |search|
	      		if search['name'] == "Job Title"
      				assert_job = true
      				user.field_key["Job Title"] = search['key']
  					user.save
      			end
      			if search['name'] == "Website"
	      			assert_website = true
	      			user.field_key["Website"] = search['key']
  					user.save
      			end
      		end
      		unless assert_job
	      		add_field_to_user(user, "Job Title")
      		end
      		unless assert_website
	      		add_field_to_user(user, "Website")
      		end
      		#successfully integrated
      		return true
      	else
      		if response["error"] == "You need to be authorized to make this request."
      			user.app_key = ""
      			user.save
      			#invalid key
      			return false
      		end
      	end
	end

	## effectively add the fields
	def self.add_field_to_user(user, field_name)
		field_api_key = false

		input_query = PIPEDRIVE_API + 'personFields?' + TOKEN + user.app_key

        response = HTTParty.post(input_query, 
        	:body => {:name =>"#{field_name}", :field_type => "varchar"},
        	:headers => {
                'Accept'=>'application/json',
                'Content-Type'=>'application/x-www-form-urlencoded',
                'User-Agent'=>'Ruby.Pipedrive.Api'
            }
        )

         unless response["data"] == nil
           	field_api_id = response["data"]["id"]
           	key_query = PIPEDRIVE_API + 'personFields/'\
            + field_api_id.to_s + "?" + TOKEN + user.app_key


            field_key_response = HTTParty.get(key_query)

            unless field_key_response["data"] == nil

           		field_api_key = field_key_response["data"]["key"]
           		user.field_key["#{field_name}"] = field_api_key
  				user.save
  			end
        end
	end

	#queries for a company name. creates when it doesn't exist.
	def self.get_or_create_company(user, company)
		org_app_id = ""
		query = PIPEDRIVE_API + 'organizations/find?term=' \
            + company + '&start=0&' + TOKEN + user.app_key
        response = HTTParty.get(query)
        #if successfull and with content, get the company app_key
        #so as not to create another with the same name
        if response["success"]
          unless response["data"] == nil
            response["data"].each do |search|
              if search['name'] == company
                org_app_id = search['id']
                #not caring about duplicates. 
                #a test will ensure we at least won't create any
                break
              end
            end
          else
            #didn't find, create one
			input_query = PIPEDRIVE_API + 'organizations?' + TOKEN + user.app_key

        	org_response = HTTParty.post(input_query, :body => {"name"=>"#{company}"}, :headers => {
                  'Accept'=>'application/json',
                  'Content-Type'=>'application/x-www-form-urlencoded',
                  'User-Agent'=>'Ruby.Pipedrive.Api'
                  })


            puts "org_response",org_response

            unless org_response["data"] == nil
            	org_app_id = org_response["data"]["id"]
            	puts "org_app_id",org_app_id
            end
          end
        else
          #error getting company
        end
        org_app_id
	end

	def self.import_lead(user, lead_to_import)
		query = PIPEDRIVE_API + 'persons?' + TOKEN + user.app_key


        response = HTTParty.post(query, :body => lead_to_import, :headers => {
                  'Accept'=>'application/json',
                  'Content-Type'=>'application/x-www-form-urlencoded',
                  'User-Agent'=>'Ruby.Pipedrive.Api'
                  })
        puts response
	end

end
