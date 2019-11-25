class AuthorsController < ApplicationController

	before_action :find_author, only: [:show, :edit, :update, :destroy]

	def index
		#@authors = Author.paginate(page: params[:page])
		@pagy, @authors = pagy(Author.all, items: 9)
    	#@full_authors = @q.result
    	# byebug
    	# respond_to do |format|
	    #   format.html
	    #   format.xls{send_data @authors.to_csv(col_sep: "\t")}
    	# end
	end

	def show
		@books = @author.books
		@authors = Author.all
	end

	def new
		@author = Author.new
	end

	def create
		@author = Author.new(author_params)
		
		if @author.save
			redirect_to authors_path
		else 
			render "new"
		end
	end

	def edit; end

	def update
		if @author.update_attributes author_params
			#flash[:success] = "Author updated"
			redirect_to @author
		else
			render "edit"
		end
	end

	def destroy
		@author.destroy
		respond_to do |format|
	      format.html { redirect_to posts_url, notice: 'Author was successfully destroyed.' }
	      format.json { head :no_content }
	      format.js 
    	end
	end


	private

		def author_params
			params.require(:author).permit(:name, :email, :info)
		end

		def find_author
			@author = Author.find(params[:id])
			return if @author
			flash[:danger] = "error"
    		redirect_to authors_path
		end
end
