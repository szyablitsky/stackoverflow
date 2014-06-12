class CommentsController < InheritedResources::Base
  before_action :authenticate_user!
  belongs_to :message
  respond_to :json
  actions :create

  def create
    unless Privilege.allowed :create_comment, for: current_user
      return head :forbidden
    end

    build_resource.author = current_user
    create! do |success, failure|
      success.json do
        channel = "/topics/#{@message.topic.id}/comments"
        data = CommentsSerializer.new(@comment).to_hash
        PrivatePub.publish_to channel, data
        render json: data
      end
      failure.json do
        render json: { errors: @comment.errors }, status: :unprocessable_entity
      end
    end
  end

  protected

  def comment_params
    params.require(:comment).permit(:body)
  end
end
