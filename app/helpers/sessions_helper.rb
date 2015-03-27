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
            if user && user.authenticated?(cookies[:remember_token], :remember)
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
    
    def current_user?(user)
        user == current_user
    end
    
    def store_destination
        session[:forwarding_url] = request.url if request.get?
    end
    
    def redirect_back_or_to(default = root_url)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
    
end
