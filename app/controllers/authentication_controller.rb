class AuthenticationController < ApplicationController

  def create
    user = User.find_by_email(params[:authy][:email])
    if user && user.authenticate(params[:authy][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      @sign_in_error = "Username or password are incorrect"
      render "mainpg/index"
    end
  end


  def destroy
    session.clear
    redirect_to root_path
  end

end
