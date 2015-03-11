module SessionsHelper
    
    
    def login(user)
        session[:user_id] = user.id
    end
    
    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        elsif cookies[:user_id]
            #raise
            user = User.find_by(id: cookies.signed[:user_id])
            if user && user.authenticated?(cookies[:remember_token])
                login user
                @current_user = user
            end
        end
    end
    
    def logged_in?
        !current_user.nil?
    end
    
    def logout
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
    
    def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
  
    def forget(user)
        user.forget
        cookies.delete(:remember_token)
        cookies.delete(:user_id)
    end
    
end
