class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    if current_user.reputation >= 50
      @message = Message.find(params[:message_id])
      params_with_author = comment_params.merge(author: current_user)
      @comment = @message.comments.create(params_with_author)
    else
      head :forbidden
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
