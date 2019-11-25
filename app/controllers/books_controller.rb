class BooksController < ApplicationController

	before_action :find_book, only: [:show, :edit, :update, :destroy]
	before_action :find_user, only:[:show]
	helper_method :sort_direction


	def index
    	@categories = Category.all
		@authors = Author.all
		@q = Book.search(params[:q])
  		@search = @q.result(distinct: true)

  		
    	@pagy, @books = pagy_countless(@search.order("created_at DESC"), items: 9)
    	# @books = Book.all.order("created_at DESC").page(params[:page]).per_page(9)
    	@sort = ["Default","Name of book", "Name of author"]
    	respond_to do |format|
	      format.html
	      format.js
	      format.json {render json: @books}
	      # format.xls{send_data @full_books.to_csv(col_sep: "\t")}
    	end
    	# byebug
	end

	
	def show
		@q = Book.search(params[:q])
  		@search = @q.result(distinct: true)
		@categories = Category.all
		@authors = Author.all
		respond_to do |format|
	      format.html
	      format.js 
	      # format.xls{send_data @full_books.to_csv(col_sep: "\t")}
    	end
	end

	def edit
	end

	def update
		# byebug
		if @book.update(book_params)
			redirect_to book_path
		else
			render 'edit'
		end
	end
	
	def new
		@book= Book.new
		# @book.bookcategories.new
	end

	def create
		@book= Book.new(book_params)
		Bookcategory.create(book_id: @book.id, category_id: params[:book][:category_ids])
		if @book.save
			redirect_to @book
		else
			flash[:danger] = "Creating book failed"
			render 'new'
		end
	end


	def destroy
		return unless @book.destroy
		redirect_to books_url
		flash[:success] = "Deleted book success"
	end

	def sort
		if params[:books]
			@books_request = convert params[:books].values
			respond_to do |format|
				format.html
				format.js
			end
		end
	end

	def convert arr
		newArr = []
		arr.each do |object|
	  		newMyObject = Book.new(object)
	  		newArr<<newMyObject
		end
		return newArr
	end
	# def followers
	# @book = Book.find(params[:book_id])
 #    @title = "Followers of book"
 #    @users = @book.followers
 #    render 'show_follow' 
 #    end

 #    def likes
	# @book = Book.find(params[:book_id])
 #    @title = "Likes of book"
 #    @users = @book.liked_users
    
 #    render 'show_follow' 
 #    end
    
	private

	def book_params
		params.require(:book).permit(:name, :quantity, :publisher, :content,
			:page, :author_id, :book_img, :category_ids,	
			bookcategories_attributes: [:book_id,:category_id])	
	end

	def find_book
		@book = Book.find(params[:id])
	end

	def find_user
		@user = current_user
	end

end
