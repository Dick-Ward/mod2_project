class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def sign_up
    @user = User.new(user_params)
    if @user.save
      session[:user_id]= current_user.id
      redirect_to "/index"
    else
      render :sign_up
    end
  end

  def like
    current_user.add_like(params[:user])
  end

  def log_in
  end

  def log_user_in
    user = User.find_by(name: params[:user][:name])
    if user.authenticate(params[:user][:password])
      current_user = user
      session[:user_id]= current_user.id
      redirect_to users_path
    else
      render :log_in
    end
  end


  def show
    @user = User.find(params[:id])
  end

  def edit
    if logged_in?
      @user= current_user
    else
      redirect_to '/log_in'
    end

  end

  def update
    current_user.update(user_params)
    if current_user.errors.any?
      render :edit
    else
    redirect_to user_path
  end
  end

  def destroy
    current_user.destroy
    redirect_to users_path
  end


private
  def user_params
    params.require(:user).permit(:name, :password, :email)
  end

end
