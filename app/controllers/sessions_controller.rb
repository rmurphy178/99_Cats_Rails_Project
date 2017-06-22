class SessionsController < ApplicationController
  before_action :require_logged_in, only: [:destroy]
  before_action :require_logged_out, only: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
    params[:user][:user_name],
    params[:user][:password]
    )
    if user.nil?
      flash.new[:errors] = ['Invalid username or password.']
      render :new
    else
      login!(user)
      redirect_to cats_url
    end
  end


  def destroy
    logout!
    redirect_to cats_url
  end


  def user_params
    params.require(:user).permit(:user_name,:password)
  end

end
