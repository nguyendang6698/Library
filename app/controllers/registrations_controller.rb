class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    redirect_to books_url
  end
end