class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @topic = Topic.find(params[:question_id])
    if @topic.answered_by? current_user
      @answered = true
    else
      params_with_author = answer_params.merge(author: current_user)
      @answer = @topic.answers.create(params_with_author)
    end
  end

  private

  def answer_params
    params.require(:message).permit(:body, attachments_attributes: [:file])
  end
end
