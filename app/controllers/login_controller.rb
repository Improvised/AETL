class LoginController < ApplicationController
  skip_before_filter :check_session

  def index
    unless params[:user].blank?
      if @user = User.login(params[:user])
        session[:user] = @user
        if session[:user][:status] == "EWAUSER"
          redirect_to "/ewazap"
        else
          redirect_to "/projects"  
        end
        
      else
        flash.now[:error] = "User and password were wrong"
      end
    end
  end

  def logout
    session[:user] = nil
    redirect_to root_path
  end
end
