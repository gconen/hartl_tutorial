module SessionsHelper
    
    
    def login(user)
        session[:user_id] = user.id
    end
    
    def current_user
        @user ||= User.find_by(id: session[:user_id])
    end
    
    def logged_in?
        !current_user.nil?
    end
    
    
end
