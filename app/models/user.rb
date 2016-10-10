class User < ApplicationRecord
  	has_many :microposts, dependent: :destroy
	validates(:name, presence: true, length: { maximum: 50 })
	validates(:email, presence: true, length: { maximum: 50 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true)
	
	has_secure_password
	
	validates(:password, presence: true, length: { minimum: 8 })
	
	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
											  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Defines a proto-feed.
	# See "Following users" for the full implementation.
  	def feed
    	Micropost.where("user_id = ?", id)
  	end
end
