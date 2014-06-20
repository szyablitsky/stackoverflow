class CommentsController < InheritedResources::Base
  before_action :authenticate_user!
  belongs_to :message
  respond_to :json
  actions :create

  load_and_authorize_resource

  def create
    build_resource.author = current_user
    create! do |success, failure|
      success.json do
        publish_new_comment
        render json: data
      end
      failure.json do
        render json: { errors: resource.errors }, status: :unprocessable_entity
      end
    end
  end

  protected

  def publish_new_comment
    channel = "/topics/#{parent.topic.id}/comments"
    data = CommentsSerializer.new(resource).to_hash
    PrivatePub.publish_to channel, data
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
