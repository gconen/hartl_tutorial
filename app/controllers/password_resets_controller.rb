class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :check_valid_user, only: [:edit, :update]
  before_action :check_not_expired, only: [:edit, :update]
  
  def new
  end
  
  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  def check_valid_user
    unless (@user && @user.activated? && @user.authenticated?(params[:id], :reset))
      redirect_to root_url
    end
  end
  
  def check_not_expired
    if @user.password_reset_expired?
      flash[:danger] = "Expired reset link"
      redirect_to new_password_reset_url
    end
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
