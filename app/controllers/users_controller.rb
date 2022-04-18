class UsersController < ApplicationController

  def new

    @user = User.new
  end

  def create
    session[:user_id] = user.id
    user = User.new(user_params)
    if user.save
      redirect_to user_path(user)
    else
      redirect_to register_path
      flash[:alert] = "#{user.errors.full_messages.to_sentence}"
    end
  end

  def login_user
    session[:user_id] = user.id
  end

  def show
    binding.pry
    @user = User.find_by_email(params[:email].downcase)
    @parties = @user.parties
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
