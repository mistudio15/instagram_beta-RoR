class User < ApplicationRecord
	has_many :posts, dependent: :destroy
	has_one_attached :avatar

	has_many :likes, dependent: :destroy
	
	validates_uniqueness_of :email
	validates_presence_of :email

	validates_presence_of :password
	validates_confirmation_of :password


	validates :username, presence: true, uniqueness: true

	def has_password?(submitted_password) #???
		password == submitted_password
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

end
