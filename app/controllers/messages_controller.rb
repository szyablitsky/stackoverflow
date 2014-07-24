class MessagesController < InheritedResources::Base
  before_action :authenticate_user!
  belongs_to :topic, route_name: :question, param: :question_id
  respond_to :js, only: [:create, :accept]
  respond_to :json, only: [:voteup, :votedown]
  actions :create, :edit, :update
  custom_actions resource: [:accept, :voteup, :votedown]

  load_and_authorize_resource

  def create
    if parent.answered_by? current_user
      @answered = true
    else
      build_resource
      resource.author = current_user
      resource.answer = true
      create! do |success, failure|
        success.js do
          AnswerNotifierWorker.perform_async(parent.id)
          parent.reload
        end
      end
    end
  end

  def accept
    resource.update_attribute :accepted, true
    ReputationService.process :accept, resource, current_user
  end

  def voteup
    render json: VoteService.process(:voteup, resource, current_user)
  end

  def votedown
    render json: VoteService.process(:votedown, resource, current_user)
  end

  protected

  def message_params
    params.require(:message).permit(:body, attachments_attributes: [:file])
  end
end
