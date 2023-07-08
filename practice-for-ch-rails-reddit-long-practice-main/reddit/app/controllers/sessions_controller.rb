class SessionsController < ApplicationController
    before_action :require_logged_in, only: [:destroy]
    before_action :require_logged_out, only: [:new, :create]
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.find_by_credentials(
            username: params[:user][:username], 
            password: params[:user][:password])
       if @user.nil?
        flash.now[:errors] = ["Invalid username and/or password"]
        render :new
       else
        log_in(@user)
        redirect_to users_url
       end   
    end

    def destroy
        user.log_out
        redirect_to new_session_url
    end
end
