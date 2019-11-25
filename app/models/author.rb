class Author < ApplicationRecord

	has_many :books, dependent: :destroy
	has_many :follows, as: :target, dependent: :destroy
		
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 50 }
  	validates :email, presence: true, length: { maximum: 255 },
					 format: { with: VALID_EMAIL_REGEX }, 
					 uniqueness: { case_sensitive: false }
	

	has_attached_file :author_img, styles: { author_index: "250x350>", author_show: "325x475>" }, default_url: "/assets/missing_author.png"
  	validates_attachment_content_type :author_img, content_type: /\Aimage\/.*\z/
	
end
