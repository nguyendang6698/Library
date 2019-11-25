class CartsController < ApplicationController
	# before_action :set_user
	before_action :find_user
	# before_action :find_book, only: [:new, :create, :show]
	before_action :find_cart, only: [:decline,:undo_quantity,:destroy,:accept]
	# before_action :find_request, only: [:destroy]
	# before_action :find_user_cart, only: [:update_request_params,:accept,:decline,:confirm, :update_quantity,:show]
	before_action :find_detail_cart, only: [:detail]
	before_action :cart_and_request, only:[:show,:confirm,:update_request_params]

	def index
		@carts = Cart.carts_admin.order("created_at DESC")
	end

	def show
		@requests = @list_requests.order("created_at DESC")
		# respond_to do |format|
		# 	    format.html
		#     	format.js
		#     	format.json{render json: @requests}
		# end
	end

	def detail
		@requests_detail = Request.where(cart_id: @cart_detail.id)
	end

	def my_cart
		return @carts = Cart.where("verify not like '3' and user_id"+"= "+ @user.id.to_s).order("created_at DESC") if user_signed_in?
	end

	# def get_request_params dateto, number
	# 	dateto = params["dateto"] # get dateto tu tren view ve 
	# 	number = params["number"] # get number tu tren view ve
	# 	update_request_params(dateto,number)

	# end

	def update_request_params dateto,number
		session[:dateto] = dateto
		session[:number] = number
		book_arr = []
		check = 0
		@list_requests.each_with_index do |r,dem|
			if dateto  && number
				book_arr[dem] = Book.find(r.book_id)
				if book_arr[dem].quantity >= session[:number][dem].to_i && session[:dateto][dem].to_date > Time.zone.now.to_date
					r.update_attributes(number: session[:number][dem].to_i,datefrom: Time.zone.now.to_date, dateto: session[:dateto][dem].to_date)
					book_arr[dem].quantity = book_arr[dem].quantity - r.number
				else
					check = 3
					break
				end
			end
		end
		# if verify == 3 return = 0 update quantity
		if check == 0
			book_arr.each_with_index do |b,index|
				book = Book.find_by(id:b.id)
				book.update_attributes(quantity: b.quantity)
			end
			@cart.update_attributes(verify: 0)
		else
			return nil
		end
	end

	def confirm
		dateto = params["dateto"] # get dateto tu tren view ve 
		number = params["number"] # get number tu tren view ve
		update_request_params dateto, number
		@user.carts.create if @cart.verify == 0 
		respond_to do |f|
			f.js 
		end
	end

	def accept 
	    @cart.verify = 1
	    if @cart.save
	    	# RequestMailer.reply_email(@request).deliver
	    	# flash[:success] = "Accept request"
	    	redirect_to carts_url
	    else
	    	# render action: "index"
		end
  	end

  	

  	def decline
	    	undo_quantity
	    	redirect_to carts_url if @cart.save
	    	# RequestMailer.reply_email(@request).deliver
	    	# flash[:danger] = "Decline request"
  	end	

  	def update_request
  		
  	end

  	def destroy
  		undo_quantity 
  		redirect_to "/my_cart/:id(.:format)" if @cart.destroy
  	end
	
	private

		def find_book
			@book = Book.find(params[:book_id])
		end

		def find_user
			@user = current_user
		end

		def find_cart

			@cart = Cart.find(params[:id])
		end

		def find_user_cart
			@cart = Cart.find(params[:id])
		end

		def find_detail_cart
			@cart_detail = Cart.find(params[:id])
		end

		def find_request
			@requests = Request.where(cart_id: @cart.id)
		end

		def cart_and_request
			@cart = Cart.find(params["id"])
			@list_requests = Request.where("cart_id = "+@cart.id.to_s)
		end

		def request_params
			params.require(:request).permit(:number,:dateto)
		end

		def undo_quantity
		 	@requests = Request.where("cart_id = "+ @cart.id.to_s)
			@requests.each do |r|
				@book = Book.find(r.book_id)
				@book.update_attributes(quantity: @book.quantity + r.number)
			end
			@cart.verify = 2
		end 
end
