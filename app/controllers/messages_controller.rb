class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @topic = Topic.find(params[:question_id])
    @answer = @topic.answers.create(answer_params)
  end

  private

  def answer_params
    params.require(:message).permit(:body)
  end
end
