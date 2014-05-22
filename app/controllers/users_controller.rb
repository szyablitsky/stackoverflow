class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  respond_to :html, only: [:update]

  def show
    @user = User.find(params[:id])
    @questions = Topic.with_questions_by @user
    @answers = Topic.with_answers_by @user
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if current_user.id.to_s == params[:id]
      @user = User.find(params[:id])
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
