class UsersController < ApplicationController
  def new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Welcome to the Sample App'
      login(@user)
      redirect_to @user
    else
      render 'new'
    end
    
  end
  
  def edit
    @user = User.find(params[:id])
  end
  

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #do things
    else
      render 'edit'
    end
  end

  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
end
