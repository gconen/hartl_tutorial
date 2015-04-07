class UsersController < ApplicationController
  before_action :check_logged_in_user, only: [:edit, :update, :index]
  before_action :check_correct_user, only: [:edit, :update]
  before_action :check_admin_status, only: [:destroy]
  
  def new
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Check your email account for an activation email"
      redirect_to root_url
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
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User Deleted"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def check_logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in to access that page"
        store_destination
        redirect_to login_url
      end
    end
    
    def check_correct_user
      unless current_user?(User.find(params[:id])) && !(current_user.admin?)
        flash[:danger] = "You can only edit your own page!"
        redirect_to root_url
      end
    end
    
    def check_admin_status
      unless current_user && current_user.admin? # have to check if current user exists
        flash[:danger] = "No."                  #if current user is nil get an error for current_user.admin?
        redirect_to root_url
      end
    end
  
end
