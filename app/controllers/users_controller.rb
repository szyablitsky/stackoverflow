class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  respond_to :html, only: [:update]

  def show
    @user = User.find(params[:id])
    @questions = Topic.joins(:question).where(messages: {author_id: @user})
    @answers = Topic.joins(:answers).where(messages: {author_id: @user}).distinct
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user
      @user.update(user_params)
      respond_with @user
    else
      render nothing: true, status: :forbidden
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
