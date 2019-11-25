class User < ApplicationRecord

	attr_accessor :remember_token
	before_save { self.email = email.downcase }

	#ManytoMany User_Like_Book
	has_many :likes, dependent: :destroy
	has_many :liked_books, through: :likes, source: :book	
	#ManytoMany User_Review_Book
	has_many :reviews, dependent: :destroy
	has_many :reviewed_books, through: :reviews, source: :book
	#OneToMany Request pending shopee..
	has_many :requests, dependent: :destroy
	#has_many :requests, dependent: :destroy
	has_many :book, through: :request
	#ManytoMany User_follow
	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id",
									dependent:         :destroy

	has_many :passive_relationships, class_name: "Relationship",
									 foreign_key: "followed_id",
									 dependent:	  :destroy

	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	#ManytoMany User_follow book, author
	has_many :follows, dependent: :destroy
	has_many :following_books, through: :follows, source: :target, :source_type => 'Book'
	has_many :following_authors, through: :follows, source: :target, :source_type => 'Author'


	#Validate
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 50 }
  	validates :email, presence: true, length: { maximum: 255 },
					 format: { with: VALID_EMAIL_REGEX }, 
					 uniqueness: { case_sensitive: false }
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
	has_secure_password


	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
													  BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# returns a random token
	def User.new_token
		SecureRandom.urlsafe_base64
	end 

	#  remember a user in the database for use in persistent sessions
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# return true if the given token matches the digest
	def authenticated?(attribute, token)
		digest = send("#{attribute}_digest")
		  return false if digest.nil?
		  BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def follow(other_user)
		following << other_user
	end

	def unfollow(other_user)
		following.delete(other_user)
	end

	def following?(other_user)
		following.include?(other_user)
	end

	def follow_book(book)
		follows.build(target_id: book.id, target_type: "Book").save
	end

	def follow_author(author)
		follows.build(target_id: author.id, target_type: "Author").save
	end

	def unfollow_book(book)
		follows.find_by(target_id: book.id, target_type: "Book").destroy
	end

	def unfollow_author(author)
		follows.find_by(target_id: author.id, target_type: "Author").destroy
	end

	def following_book?(book)
		dem = follows.where(target_id: book.id, target_type: "Book").count
		dem == 1
	end

	def following_author?(author)
		dem = follows.where(target_id: author.id, target_type: "Author").count
		dem == 1
	end

	def like_book(book)
		liked_books << book
	end

	def unlike_book(book)
		liked_books.delete(book)
	end

	def like_book?(book)
		liked_books.include?(book)
	end

	def self.to_csv(option ={})
		CSV.generate(option) do |csv|
			csv << column_names
			all.each do |user|
				csv << user.attributes.values_at(*column_names)
			end
		end
	end
end

