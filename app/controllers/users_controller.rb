class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def show

  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "User updated"
    else
      render :edit  
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: "User deleted"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
