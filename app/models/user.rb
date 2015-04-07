require "bcrypt"

class User < ActiveRecord::Base
	has_many :leads
	serialize :field_key, Hash

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }, on: :create
	#allowing us to edit only APP_KEY from user
	validates_presence_of :name, :password, :password_confirmation, on: :create
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

	## searches for "Job Title" and "Website" (or any other field)
  ## on the user's pipedrive acc. if any is missing, create it
	## even if already populated the field key will always be replaced
	def self.assert_or_integrate(user)

    #the fields listed here will be created as PersonFields in pipedrive
    #and their key will be added to user.field_key hash
    field_name = ["Job Title", "Website" ]

    field_key = Rdgem.assert_fields(field_name, user.app_key)

    #wrong app key error
    unless field_key 
      #blanking out app_key
      user.app_key = ""
      user.save
      return false
    else
      #fill in the user's field_key hash
      field_name.each do |fill|
        user.field_key["#{fill}"] = field_key["#{fill}"]
      end
      user.save
      return true
    end
    return false
 	end
end