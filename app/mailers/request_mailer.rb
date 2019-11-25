class RequestMailer < ApplicationMailer
	default from: "16tclc3@gmail.com"

  def borrow_email(user, request)
    @user = user
    @request = request

    mail to: @user.email, subject: "Borrow request"
  end
  def reply_email(request)
  	@request = request
  	@user = @request.user
  	mail to: @user.email, subject: "Reply request"
  end
end
