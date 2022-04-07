class UsersController < ApplicationController

  def new

    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to user_path(user)
    else

      redirect_to register_path

      flash[:alert] = "#{user.errors.full_messages.to_sentence}"
    end
  end

  def show
    @user = User.find(params[:id])
    @parties = @user.parties
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
