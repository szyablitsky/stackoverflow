class CommentsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  def create
    if current_user.reputation < Privilege.create_comment
      return head :forbidden
    end

    @message = Message.find(params[:message_id])
    params_with_author = comment_params.merge(author: current_user)
    @comment = @message.comments.build(params_with_author)
    if @comment.save
      channel = "/topics/#{@message.topic.id}/comments"
      data = CommentsService.new(@comment).to_hash
      PrivatePub.publish_to channel, data
      render json: data
    else
      render json: { errors: @comment.errors }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
