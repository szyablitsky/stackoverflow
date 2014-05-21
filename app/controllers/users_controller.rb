class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @questions = Topic.joins(:question).where(messages: {author_id: @user})
    @answers = Topic.joins(:answers).where(messages: {author_id: @user}).distinct
  end
end
