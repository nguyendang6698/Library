class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  	after_create :create_cart
  	 devise :database_authenticatable, :registerable,
          :rememberable
          validates_uniqueness_of :email, case_sensitive: false

  	#ManytoMany User_Like_Book
	# has_many :likes, dependent: :destroy
	# has_many :liked_books, through: :likes, source: :book	
	# #ManytoMany User_Review_Book
	# has_many :reviews, dependent: :destroy
	# has_many :reviewed_books, through: :reviews, source: :book
	# #OneToMany Request pending shopee..
	has_many :carts, dependent: :destroy
	has_many :books, through: :cart



	def create_cart
		if self.save
			return self.carts.create(verify: 3)
		end
	end


	# #ManytoMany User_follow
	# has_many :active_relationships, class_name: "Relationship",
	# 								foreign_key: "follower_id",
	# 								dependent:         :destroy

	# has_many :passive_relationships, class_name: "Relationship",
	# 								 foreign_key: "followed_id",
	# 								 dependent:	  :destroy

	# has_many :following, through: :active_relationships, source: :followed
	# has_many :followers, through: :passive_relationships, source: :follower
	# #ManytoMany User_follow book, author
	# has_many :follows, dependent: :destroy
	# has_many :following_books, through: :follows, source: :target, :source_type => 'Book'
	# has_many :following_authors, through: :follows, source: :target, :source_type => 'Author'

	# def follow(other_user)
	# 	following << other_user
	# end

	# def unfollow(other_user)
	# 	following.delete(other_user)
	# end

	# def following?(other_user)
	# 	following.include?(other_user)
	# end

	# def follow_book(book)
	# 	follows.build(target_id: book.id, target_type: "Book").save
	# end

	# def follow_author(author)
	# 	follows.build(target_id: author.id, target_type: "Author").save
	# end

	# def unfollow_book(book)
	# 	follows.find_by(target_id: book.id, target_type: "Book").destroy
	# end

	# def unfollow_author(author)
	# 	follows.find_by(target_id: author.id, target_type: "Author").destroy
	# end

	# def following_book?(book)
	# 	dem = follows.where(target_id: book.id, target_type: "Book").count
	# 	dem == 1
	# end

	# def following_author?(author)
	# 	dem = follows.where(target_id: author.id, target_type: "Author").count
	# 	dem == 1
	# end

	# def like_book(book)
	# 	liked_books << book
	# end

	# def unlike_book(book)
	# 	liked_books.delete(book)
	# end

	# def like_book?(book)
	# 	liked_books.include?(book)
	# end
end
