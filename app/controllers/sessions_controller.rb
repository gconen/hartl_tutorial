class SessionsController < ApplicationController
  
  def destroy
    logout
    redirect_to root_path
  end  
  
  def new
    
  end
  
  def create
    user = User.find_by(email: login_params[:email].downcase)
    if user && user.authenticate(login_params[:password])
      login(user)
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
