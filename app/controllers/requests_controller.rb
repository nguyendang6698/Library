class RequestsController < ApplicationController

	# before_action :find_book, only: [:new, :create]
	before_action :find_user, only: [:new, :create, :destroy]
	before_action :find_book, only: [:new, :create]
	before_action :find_request, only: [:destroy]
	after_action :last_rq, only: [:create]
	def new
		@request = Request.new
	end

	def create
		return if @user.nil?
		@request= Request.new

		if @user.carts.last && @user.carts.last.verify == 3
			book_ids = book_ids @user.carts.last.requests
			check = book_ids.include? @book.id
			@request.cart_id = @user.carts.last.id
			@request.book_id = @book.id if @book.quantity > 0 && check == false
		else
			@request.cart_id = (@user.carts.create).id
			@request.book_id = @book.id if @book.quantity > 0
		end
		if @request.save
			# @last_id = Request.get_last_rq
			respond_to do |format|
			    format.html
		    	format.js
		    	# format json {render: @request.id}
		    end
		else
			
		end
	end

	def destroy
		if @request.destroy
			redirect_to cart_path(@user.carts.last.id)
		else
		 	redirect_to books_url
		end
	end

	def book_ids requests
		arr = []
		requests.each do |r|
			arr << r.book_id
		end
		return arr
	end
	# get object append vao cart
	def get_rq_json
		request = Request.last
		respond_to do |format|
		    	format.json{render json: request}
		end
	end
	
	private
		def find_book
			@book = Book.find(params[:book_id])
		end

		def find_user
			@user = current_user
		end

		def find_cart
			@cart = Cart.find(@request.cart.id)
		end

		def find_request
			@request = Request.find(params[:id])
		end

		def last_rq
			session[:request_id] = @request.id
			# byebug 
		end
end
