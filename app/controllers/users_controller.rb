class Users::SessionsController < Devise::SessionsController
   def after_sign_up_path_for(resource)
      redirect books_url
      # current_user.carts.create
    end
end