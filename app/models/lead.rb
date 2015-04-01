class Lead < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :name, :last_name, :email, :company, :job_title, :phone, :website, :user_id
end
