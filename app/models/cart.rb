class Cart < ApplicationRecord
	
	belongs_to :user

	# attr_accessor :current_user

	has_many :requests, dependent: :destroy
		
	has_many :books, through: :request, source: :book

	scope :carts_admin, -> {where "verify not like '3'"} 

	# scope :carts_user, -> {where user_id: current_user.id, verify: !3}

	

end
