class Api::V1::MessagesController < Api::V1::BaseController
  respond_to :json, only: [:index, :show, :create]
  belongs_to :topic, parent_class: Topic, param: :question_id

  def index
    respond_with MessagesSerializer.to_hash(collection)
  end

  def show
    respond_with MessagesSerializer.new(resource).to_hash type: :api_resource
  end

  def create
    if parent.answered_by? current_resource_owner
      head :forbidden
    else
      build_resource
      resource.author = current_resource_owner
      resource.answer = true
      create! do |success, failure|
        success.json do
          render json: MessagesSerializer.new(resource).to_hash(type: :api_resource)
        end
      end
    end
  end

  private

  def collection
    @messages ||= parent.answers
  end

  def message_params
    params.require(:message).permit(:body)
  end
end
