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
      login(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
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
