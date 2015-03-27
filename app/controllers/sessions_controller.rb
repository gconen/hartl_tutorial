class SessionsController < ApplicationController
  
  def destroy
    logout if logged_in?
    redirect_to root_path
  end  
  
  def new
    
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or_to user
      else
        flash[:warning] = "Account Not Activated: check your email for activation link"
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
    
  end
  
  private
  
  def login_params
    params.require(:session).permit(:email, :password)
  end
  
  

  #
end
