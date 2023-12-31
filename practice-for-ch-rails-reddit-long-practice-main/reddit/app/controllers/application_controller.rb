class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?

    #crrlll
    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def require_logged_in
        redirect_to new_session_url if !logged_in?
    end

    def require_logged_out
        redirect_to users_url if logged_in?
    end

    def logged_in?
        !!current_user
    end

    def log_in(user)
        session[:session_token] = user.reset_session_token!
    end

    def log_out 
        current_user.reset_session_token! if logged_in?
        @current_user = nil
        session[:session_token] = nil
    end
end
