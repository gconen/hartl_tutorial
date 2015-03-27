class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user && user.authenticated?(params[:id], :activation) && !(user.activated?)
            user.activate
            
            flash[:success] = 'Welcome to the Sample App'
            login user
            redirect_to user
        else
            flash[:danger] = "Invalid Activation Link"
            redirect_to root_url
        end
    end
end
