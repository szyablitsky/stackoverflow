class Api::V1::TopicsController < Api::V1::BaseController
  respond_to :json, only: [:index, :show, :create]
  actions :index, :show, :create
  defaults resource_class: Topic

  def index
    respond_with TopicsSerializer.to_hash(collection)
  end

  def show
    respond_with TopicsSerializer.new(resource).to_hash type: :api_resource
  end

  def create
    build_resource.question.author = current_resource_owner
    create! do |success, failure|
      success.json do
        TagService.process params[:topic][:tags], for: resource
        render json: TopicsSerializer.new(resource).to_hash(type: :api_resource)
      end
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, question_attributes: [:id, :body])
  end
end
