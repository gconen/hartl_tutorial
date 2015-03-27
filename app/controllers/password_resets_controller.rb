class PasswordResetsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:password_reset][:email].downcase)
    if user
      user.create_reset_token
      user.send_reset_email
      flash[:info] = "Reset email sent"
      redirect_to root_url
    else
      flash.now[:danger] = "Email not found in system"
      render 'new'
    end
  end

  def edit
  end
end
