require "bcrypt"

class User < ActiveRecord::Base
	has_many :leads


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
	## then flip the integrated flag to quicken future queries
	def self.assert_or_integrate(user)

		assert_job = false
		assert_website = false

		query = 'https://api.pipedrive.com/v1/personFields?api_token=' + user.app_key
      	response = HTTParty.get(query)
      			
      	#only 1 outside query saves time.
      	if response["success"]
      		response["data"].each do |search|
	      		if search['name'] == "Job Title"
      				assert_job = true
      			end
      			if search['name'] == "Website"
	      			assert_website = true
      			end
      		end
      		unless assert_job
	      		add_field_to_user(user, "Job Title")
      		end
      		unless assert_website
	      		add_field_to_user(user, "Website")
      		end
      	else
      		#proc creation error
      	end

      	#todo set integrated to 1		
	end

	## effectively add the fields
	def self.add_field_to_user(user, field_name)
		custom_field = Pipedrive::PersonField.new(user.app_key)

  		response = custom_field.create({ name: field_name, field_type: "varchar" })

  		if response["success"]
  			field_info = custom_field.find(response["data"]["id"])
  			field_api_key = field_info["data"]["key"]
  		else
  			#proc creation error
  		end

	end

	#queries for a company name. creates when it doesn't exist.
	def self.get_or_create_company(user, company)
		org_app_id = ""
		query = 'https://api.pipedrive.com/v1/organizations/find?term=' \
            + company + '&start=0&api_token=' + user.app_key
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
            org = Pipedrive::Organization.new(user.app_key)
            org_response = org.create({ name: company })

            org_app_id = org.id_from_response(org_response)
          end
        else
          #error getting company
        end
        org_app_id
	end

end
