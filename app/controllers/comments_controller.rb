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
        data = CommentsSerializer.new(resource).to_hash type: :private_pub

        channel = "/topics/#{parent.topic.id}/comments"
        PrivatePub.publish_to channel, data

        render json: data
      end

      failure.json do
        render json: { errors: resource.errors }, status: :unprocessable_entity
      end
    end
  end

  protected

  def comment_params
    params.require(:comment).permit(:body)
  end
end
