class UsersController < ApplicationController
  before_action :check_logged_in_user, only: [:edit, :update]
  
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
      flash[:success] = "Thank you for updating your information"
      redirect_to @user
    else
      render 'edit'
    end
  end

  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def check_logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in to access that page"
        redirect_to login_url
      end
    end
  
end
