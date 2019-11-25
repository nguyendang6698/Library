module ApplicationHelper
  include Pagy::Frontend
  
  def full_title(page_title = '')
    base_title = "Rails LibraryVLC"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def cart_id
     @cart = Cart.where(user_id: current_user.id).last if current_user 
     if @cart 
        if @cart.verify == 3
          return @cart.id
        else
          return @cart.id+1
        end
     else 
        return nil
     end 
  end

  def cart
      @cart = Cart.where(user_id: current_user.id).last if current_user 
      if @cart 
        return @cart
      else 
        return nil
      end
  end

  def requests 
    @cart = cart
    if  @cart.nil? || @cart.verify != 3
      return nil 
    else
      @requests = Request.where(cart_id: @cart.id).order("created_at DESC")
      return @requests
    end
  end

  def check_status (cart)
      if cart.verify == 0 
        return "Pending"
      elsif cart.verify == 1 
        return "Accept"
      elsif cart.verify == 2
        return "Decline"
      end
  end
  
  #kiem tra xem item co trong gio chua
  def check_item_cart book_id
     return if requests.nil?
      check = (book_ids requests).include? book_id
  end


  def book_ids requests
    return if requests.nil?
    arr = []
    requests.each do |r|
      arr << r.book_id
    end
    return arr
  end

  #get id new request
  def new_request
    return Request.get_last_rq
  end

end
