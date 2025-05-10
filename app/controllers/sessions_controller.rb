class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id #вот эта сесия принадлежит вот этому юзеру!\
      redirect_to root_path
    else
      render :new    
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path
  end

end
