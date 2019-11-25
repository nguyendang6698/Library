module BooksHelper
	def get_authors id
		Author.order(id)
	end
	def get_categories id
		Category.order(id)
	end

	def get_quantity book_id
		if Book.find(book_id).quantity > 0
			return Book.find(book_id).quantity  
		else
			return 0;
		end
	end
end
