class User < ApplicationRecord
  	has_many :microposts, dependent: :destroy
	has_many :comments, dependent: :destroy
  	
  	has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

    has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

    has_many :following, through: :active_relationships, source: :followed

  	has_many :followers, through: :passive_relationships, source: :follower

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
      Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
  	end

	# Follows a user.
	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	# Unfollows a user.
	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end
end
